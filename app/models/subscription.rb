class Subscription < ActiveRecord::Base

  attr_accessor :cancel_reason

  # -------------- SECTION FOR ASSOCIATIONS --------------------
  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :plan
  has_many :details, class_name: 'SubscriptionDetail', dependent: :destroy
  has_one :refund, dependent: :destroy

  # -------------- SECTION FOR VALIDATIONS --------------------
  # -------------------------------------------------------------
  before_validation :calculate_total_amount, :calculate_total_quantity
  validates :user, :plan, :amount, presence: true
  validate :valid_state

  # -------------- SECTION FOR CALLBACKS --------------------
  # -------------------------------------------------------------
  before_create :set_default_state
  after_create :notify_admin_about_new_subscription, :notify_user_for_subscription_placed
  after_commit :notify_admin_about_subscription_cancellation, if: :cancelled?

  # -------------- SECTION FOR SCOPES --------------------
  # -------------------------------------------------------------
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :current_month_deliveries, -> { joins('LEFT OUTER JOIN subscription_details ON subscription_details.subscription_id = subscriptions.id').where(cancelled: false, completed: false).group("subscriptions.id").having("COALESCE(MAX(subscription_details.last_delivered_at), to_date('01 Jan 0000', 'DD Mon YYYY')) <= :first_date_current_month", { first_date_current_month: DateTime.now.at_beginning_of_month }) }
  scope :pending_payments, -> { joins('LEFT OUTER JOIN subscription_details ON subscription_details.subscription_id = subscriptions.id').where(cancelled: false, completed: false).group("subscriptions.id").having('COALESCE(SUM(subscription_details.last_payment_received), 0) < subscriptions.amount').uniq }
  scope :pending_deliveries, -> { joins('LEFT OUTER JOIN subscription_details ON subscription_details.subscription_id = subscriptions.id').where('subscription_details.last_delivered_at IS NULL AND subscription_details.last_dispatched_at IS NOT NULL AND subscriptions.cancelled = FALSE AND subscriptions.completed = FALSE').uniq }
  scope :cancelled_ones, -> { inactive.where(cancelled: true) }
  scope :completed_ones, -> { inactive.where(completed: true) }

  def remaining_units_to_be_delivered
    plan.units - units_delivered
  end

  def units_delivered
    details.sum(:units)
  end

  def remaining_cost_of_units_to_be_delivered
    cost_of_units_delivered = units_delivered * plan.price + (units_delivered * plan.price * Constants::VAT_RATE)
    collected_amount - cost_of_units_delivered
  end

  def collected_extra_amount?
    !!(remaining_cost_of_units_to_be_delivered > 0)
  end

  def outstanding_amount?
    (remaining_cost_of_units_to_be_delivered < 0)
  end

  def outstanding_amount
    -remaining_cost_of_units_to_be_delivered
  end

  def remaining_amount_to_be_collected
    (amount - collected_amount).round(2)
  end

  def collected_amount
    details.sum(:last_payment_received).to_f
  end

  def difference_between_plans(new_plan)
    new_amount = new_plan.amount_including_taxes
    new_amount - remaining_cost_of_units_to_be_delivered
  end

  def amount_to_be_returned?(new_plan)
    !!(difference_between_plans(new_plan) < 0)
  end

  def cancel(reason)
    if reason.nil?
      errors[:base] << 'No reason provided for cancellation'
      return false
    end

    status = false
    if remaining_cost_of_units_to_be_delivered > 0
      user.refunds.create!(subscription_id: id, amount: remaining_cost_of_units_to_be_delivered, comments: reason, subscription_id: id)
      status = true
    elsif remaining_cost_of_units_to_be_delivered < 0
      errors[:base] << "You have outstanding amount of INR #{ outstanding_amount } for your subscription"
      status = false
    else
      status = true
    end
    status ? update(active: false, cancelled: true) : false
  end

  def status
    if cancelled?
      'Cancelled'
    elsif completed?
      'Completed'
    elsif active?
      'Active'
    else
      'Invalid'
    end
  end

  def last_delivery_date
    details.maximum(:last_delivered_at)
  end

  def last_dispatch_date
    details.maximum(:last_dispatched_at)
  end

  # If it returns nil, it means that subscription is complete
  def next_delivery_date
    next_date = (last_delivery_date ? last_delivery_date.at_beginning_of_month.next_month : DateTime.now)
    next_date unless completed?
  end

  def box_dispatched_for_current_month?
    DateTime.now.at_beginning_of_month.to_s(:long) == last_dispatch_date.at_beginning_of_month.to_s(:long) if last_dispatch_date
  end

  # If last delivery date is null, it means we have not delivered a single box. So return true
  def delivery_to_be_made_in_current_month?
    if last_delivery_date
      DateTime.now.at_beginning_of_month >= last_delivery_date.at_beginning_of_month
    else
      true
    end
  end

  def dispatch
    details.create(last_dispatched_at: DateTime.now, units: 1)
  end

  def deliver(detail)
    if detail.last_dispatched_at.nil?
      errors[:base] << 'Box needs to be dispatched first before it can be marked as delivered'
      return false
    end
    detail.update!(last_delivered_at: DateTime.now)
  end

  def receive_payment(detail, payment)
    if detail.last_delivered_at.nil?
      errors[:base] << 'Box needs to be delivered first before it can receive payment'
      return false
    end

    detail.update!(last_payment_received_at: DateTime.now, last_payment_received: payment)
  end

  protected

    def calculate_total_amount
      self.amount = plan.amount_including_taxes
      self.to_be_returned = false
      true
    end

    def calculate_total_quantity
      self.remaining_units = plan.units
      true
    end

    def set_default_state
      self.active = true
      self.completed = false
      self.cancelled = false
      true
    end

    def notify_admin_about_new_subscription
      AdminMailer.subscription_received(User.admin_ids ,user_id, id).deliver
    end

    def notify_user_for_subscription_placed
      UserMailer.notify_user_about_subscription(user_id, id).deliver
    end

    def notify_admin_about_subscription_cancellation
      AdminMailer.subscription_cancelled_by_user(User.admin_ids ,user_id, id).deliver
    end

    def valid_state
      errors[:base] << 'Cannot cancel as a valid state is not specified' unless (active? || cancelled? || completed?)
      errors[:base] << 'Cannot be both in cancelled and completed state' if (cancelled? && completed?)
      errors[:base] << 'Invalid state attempt. Please contact us for more info' if (active? && (cancelled? || completed?))
    end

end
