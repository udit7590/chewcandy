class User < ActiveRecord::Base
  attr_accessor :same_as_billing_address
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # -------------- SECTION FOR ASSOCIATIONS --------------------
  # -------------------------------------------------------------
  has_one :shopping_cart, -> { where active: true }, dependent: :destroy
  has_many :shopping_carts, -> { where active: false }, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_one :billing_address, -> { where primary: true }, class_name: 'Address', dependent: :destroy
  has_one :shipping_address, -> { where primary: false }, class_name: 'Address', dependent: :destroy
  has_many :subscriptions, -> { where(active: true) }, dependent: :destroy
  has_many :past_subscriptions, -> { where(active: false) }, class_name: 'Subscription', dependent: :destroy
  has_many :refunds, -> { where(complete: false) }, dependent: :destroy
  has_many :completed_refunds, -> { where(complete: true) }, class_name: 'Refund', dependent: :destroy

  has_many :blog_posts, dependent: :restrict_with_error
  
  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address, reject_if: :all_blank

  # -------------- SECTION FOR VALIDATIONS --------------------
  # -------------------------------------------------------------
  # validates :email, unique: true
  validates :first_name, length: { maximum: 50, allow_blank: true }
  validates :last_name, length: { maximum: 50, allow_blank: true }
  validates :phone_number, length: { maximum: 14 }

  # -------------- SECTION FOR CALLBACKS --------------------
  # -------------------------------------------------------------
  after_create :notify_user_for_successfull_registration, unless: :guest?

  # -------------- SECTION FOR SCOPES --------------------
  # -------------------------------------------------------------
  scope :registered, -> { where(guest: false) }
  scope :guests, -> { where(guest: true) }

  def self.admin_ids
    User.where(admin: true).pluck(:id)
  end

  def full_billing_address
    if billing_address
      (billing_address.full_address + "<br />" + billing_address.city + ', ' + billing_address.state + ' - ' + billing_address.pincode.to_s + '<br />' + billing_address.country).html_safe
    end
  end

  def full_shipping_address
    if shipping_address
      (shipping_address.full_address + "<br />" + shipping_address.city + ', ' + shipping_address.state + ' - ' + shipping_address.pincode.to_s + '<br />' + shipping_address.country).html_safe
    end
  end

  def name
    guest? ? ((first_name.to_s + ' ' + last_name.to_s).strip.presence || 'Guest') : ((first_name.to_s + ' ' + last_name.to_s).strip.presence || 'Anonymous')
  end

  # No longer required
  def update_subscription(new_plan)
    new_subscription_amount = new_plan.amount_including_taxes

    if subscription.present?
      old_subscription = subscription
      subscription.update!(active: false)
      if old_subscription.remaining_cost_of_units_to_be_delivered > 0
        refunds.create!(subscription_id: old_subscription.id, amount: old_subscription.remaining_cost_of_units_to_be_delivered)
      else
        new_subscription_amount += old_subscription.remaining_cost_of_units_to_be_delivered.abs
      end
    end
    create_subscription({
      active: true,
      amount: new_subscription_amount,
      to_be_returned: false,
      plan_id: new_plan.id,
      user_id: id
    })
  end

  protected

    def notify_user_for_successfull_registration
      UserMailer.notify_user_registrered(id).deliver
    end
end
