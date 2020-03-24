class Refund < ActiveRecord::Base
  # -------------- SECTION FOR ASSOCIATIONS --------------------
  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :subscription
  belongs_to :order
  
  # -------------- SECTION FOR SCOPES --------------------
  # -------------------------------------------------------------
  scope :active, -> { where(complete: false) }
  scope :inactive, -> { where(complete: true) }

  # -------------- SECTION FOR VALIDATIONS --------------------
  # -------------------------------------------------------------
  validates :user, presence: true
  validate :order_or_subscription_present
  validates :comments, length: { minimum: 2, maximum: 1500 }
  validates :amount, numericality: { greater_than: 0 }

  def status
    complete? ? 'Refunded' : 'Pending'
  end

  def for_string
    order_id ? 'Order' : 'Subscription'
  end

  def process
    return false if complete?

    update(complete: true)
  end

  def completed?
    complete?
  end

  def process!
    update!(complete: true)
  end

  protected

    def order_or_subscription_present
      errors[:base] << 'Refund must be associated with an order or a subscription' unless (order.present? || subscription.present?)
    end
end
