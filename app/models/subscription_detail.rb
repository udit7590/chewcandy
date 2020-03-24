class SubscriptionDetail < ActiveRecord::Base

  STATUSES = { delivered: 'Delivered',
    dispatched: 'Dispatched',
    payment_received: 'Payment Received',
    in_processing: 'In Processing'
  }

  belongs_to :subscription

  after_create :complete_subscription, if: :subscription_complete?

  def status
    if last_payment_received_at
      :payment_received
    elsif last_delivered_at
      :delivered
    elsif last_dispatched_at
      :dispatched
    else
      :in_processing
    end 
  end

  def status_string
    STATUSES[status]
  end

  def status_date
    case status
    when :payment_received
      last_payment_received_at
    when :delivered
      last_delivered_at
    when :dispatched
      last_dispatched_at
    when :in_processing
      updated_at
    end 
  end

  def not_yet_dispatched?
    last_dispatched_at.nil?
  end

  def not_yet_delivered?
    last_delivered_at.nil?
  end

  def payment_not_yet_received?
    last_payment_received_at.nil? && subscription.remaining_amount_to_be_collected > 0
  end

  def mark_as_deliver
    update(last_delivered_at: DateTime.now)
  end

  def receive_payment(payment)
    update(last_payment_received_at: DateTime.now, last_payment_received: payment)
  end

  protected

    def subscription_complete?
      (subscription.plan.units == subscription.details.sum(:units)) && (subscription.amount <= subscription.details.sum(:last_payment_received))
    end

    def complete_subscription
      subscription.update!(completed: true, active: false)
    end
 end
