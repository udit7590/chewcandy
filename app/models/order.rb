class Order < ActiveRecord::Base
  include AASM
  include NumberGenerator
  extend FriendlyId

  friendly_id :number, use: :slugged, slug_column: :number

  attr_accessor :refund_reason

  # -------------- SECTION FOR ASSOCIATIONS --------------------
  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :shopping_cart
  has_one :refund
  has_many :discounts_orders
  has_one :discount, through: :discounts_orders

  # -------------- SECTION FOR VALIDATIONS --------------------
  # -------------------------------------------------------------
  validates :user, :shopping_cart, :total_product_amount, :total_quantity, :total_tax_amount, :total_shipping_amount, presence: true
  # validate :quantity_greater_than_100_and_multiple_0f_10
  # validate :amount_greater_than_150

  # -------------- SECTION FOR SCOPES --------------------
  # -------------------------------------------------------------
  scope :past, -> { where.not(state: [:placed, :dispatched]) }

  # -------------- SECTION FOR STATE MACHINE --------------------
  # -------------------------------------------------------------

  FROM_STATE_TO_STATES = {
      placed: [:dispatched, :cancelled],
      dispatched: [:delievered],
      cancelled: [],
      delievered: [:payment_received, :refund_initiated],
      payment_received: [:refund_initiated],
      refund_initiated: [:refunded, :refund_error_occurred],
      refunded: [],
      refund_error_occurred: []
    }.freeze

  STATE_EVENT_NAME = {
      dispatched: 'initiate_dispatch',
      cancelled: 'cancel',
      delievered: 'deliver',
      payment_received: 'receive_payment',
      refund_initiated: 'initiate_refund',
      refunded: 'refund_amount',
      refund_error_occurred: 'refund_error'
    }.freeze

  # Order.aasm.from_states_for_state(:refunded)
  aasm column: 'state'.freeze do
    state :placed, initial: true
    state :cancelled
    state :delievered
    state :dispatched
    state :payment_received
    state :refund_initiated
    state :refunded
    state :refund_error_occurred

    event :initiate_dispatch do
      transitions from: :placed, to: :dispatched
    end
    event :cancel do
      transitions from: :placed, to: :cancelled
    end
    event :deliver do
      transitions from: :dispatched, to: :delievered
    end
    event :receive_payment do
      transitions from: :delievered, to: :payment_received
    end
    event :initiate_refund, after: :create_refund, guards: [:check_refundable] do
      transitions from: [:payment_received, :delievered], to: :refund_initiated
    end
    event :refund_amount, before: :process_refund do
      transitions from: :refund_initiated, to: :refunded, guard: :refund_present?
    end
    event :refund_error do
      transitions from: :refund_initiated, to: :refund_error_occurred
    end
  end

  def self.events
    Order.aasm.events.map(&:name)
  end

  def list_of_states
    # Order.aasm.states_for_select
    Order.aasm.states.map { |state| state.to_s.to_sym }
  end

  def allowed_actions
    allowed_reachable_states = FROM_STATE_TO_STATES[state.to_sym]
    return [] unless allowed_reachable_states.present?

    FROM_STATE_TO_STATES[state.to_sym].map do |allowed_state|
      STATE_EVENT_NAME[allowed_state].to_sym
    end
  end

  # -------------- SECTION FOR CALLBACKS --------------------
  # -------------------------------------------------------------
  before_save :apply_discount, if: :coupon_present?
  before_create :calculate_total_amount, :calculate_total_tax, :calculate_shipping_amount, :calculate_total_quantity
  after_create :inactivate_user_cart!, :notify_user_for_order_placed, :notify_admin_about_new_order
  after_update :notify_user_about_state_change, if: [:state_changed?, :user_notify_state?]
  after_update :notify_admin_about_refund_or_cancel, if: :state_changed?

  # -------------- SECTION FOR METHODS --------------------
  # -------------------------------------------------------------

  def generate_number(options = {})
    options[:prefix] ||= 'O'
    super(options)
  end

  def identifier
    number || id
  end

  def build_from_cart
    return nil unless shopping_cart_id

    self.total_product_amount = shopping_cart.shopping_cart_items.sum(:amount)
    self.total_quantity       = shopping_cart.shopping_cart_items.sum(:quantity)
    self.total_tax_amount     = Constants::VAT_RATE * 100 * total_product_amount
    self.total_shipping_amount  = Constants::SHIPPING_AMOUNT
    self.payment_method       = Constants::DEFAULT_PAYMENT_METHOD.upcase
  end

  def total_price_including_taxes
    total_product_amount.to_f + total_tax_amount.to_f
  end

  def total_price_including_taxes_and_shipping
    total_product_amount.to_f + total_tax_amount.to_f + total_shipping_amount.to_f
  end

  def net_amount
    total_price_including_taxes_and_shipping - discount_amount.to_f
  end

  def refundable_state?
    payment_received? || delievered?
  end

  def refundable?
    refundable_state? && within_allowed_duration?
  end

  def within_allowed_duration?
    DateTime.now <= (updated_at + Constants::REFUND_MAXIMUM_DAY_CRITERIA)
  end

  def user_notify_state?
    ['dispatched', 'delievered', 'delivered'].include?(state.to_s)
  end

  protected

    def quantity_greater_than_100_and_multiple_0f_10
      errors[:base] << 'Order should have a minimum quantity of 100 grams' if shopping_cart.quantity < Constants::MINIMUM_ORDER_QUANTITY
      errors[:base] << 'Order quantity should be a multiple of 10 grams' if ((shopping_cart.quantity % 10) != 0)
    end

    def amount_greater_than_150
      errors[:base] << 'Order amount should be minimum of INR 150' if shopping_cart.total_amount < 150.0
    end

    def check_refundable
      errors[:base] << 'Your order has not been delivered yet and can\' be refunded' unless within_allowed_duration?
      !errors.present?
    end

    def calculate_total_amount
      self.total_product_amount = shopping_cart.total_amount
    end

    def calculate_total_tax
      self.total_tax_amount = shopping_cart.taxes
    end

    def calculate_shipping_amount
      self.total_shipping_amount = shopping_cart.shipping_amount
    end

    def calculate_total_quantity
      self.total_quantity = shopping_cart.quantity
    end

    def inactivate_user_cart!
      user.shopping_cart.inactivate!
    end

    def notify_user_for_order_placed
      UserMailer.notify_user_about_order_placed(user_id, id).deliver
    end

    def notify_admin_about_new_order
      AdminMailer.order_received(User.admin_ids ,user_id, id).deliver
    end

    def notify_user_about_state_change
      UserMailer.notify_user_about_order_state_change(user_id, id).deliver
    end

    def notify_admin_about_refund_or_cancel
      if cancelled?
        AdminMailer.order_cancelled_by_user(User.admin_ids ,user_id, id).deliver
      elsif refund_initiated?
        AdminMailer.refund_initiated_by_user(User.admin_ids ,user_id, id).deliver
      end
    end

    def create_refund
      create_refund!(user_id: user_id, amount: total_price_including_taxes, comments: @refund_reason || 'No reason provided')
    end

    def process_refund
      refund.process!
    end

    def refund_present?
      refund.present?
    end

    def coupon_present?
      shopping_cart.coupon_code.present?
    end

    def apply_discount
      self.coupon_code = shopping_cart.coupon_code
      self.discount_amount = shopping_cart.discount_amount
    end

end
