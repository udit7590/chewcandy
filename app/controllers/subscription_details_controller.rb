class SubscriptionDetailsController < ApplicationController
  layout 'admin'
  include UserInformation

  before_action :authenticate_user!
  before_action :check_admin
  before_action :load_subscription_detail, only: [:deliver, :receive_payment, :payment_received]
  before_action :check_already_dispatched, only: [:deliver]
  before_action :check_not_already_delivered, only: [:deliver]
  before_action :check_not_already_payment_received, only: [:receive_payment, :payment_received]
  before_action :check_already_delivered, only: [:receive_payment, :payment_received]
  before_action :check_payment_greater_than_or_equal_to_zero, only: [:payment_received]

  def deliver
    if @subscription_detail.mark_as_deliver
      redirect_to subscription_path(@subscription_detail.subscription), notice: 'Box successfully delivered'
    else
      render subscription_path(@subscription_detail.subscription), alert: "Box couldn't be delivered. Errors: @subscription_detail.errors.full_messages.join('. ')"
    end
  end

  # GET
  def receive_payment
  end

  # PATCH
  def payment_received
    if @subscription_detail.receive_payment(params[:subscription_detail][:last_payment_received].to_f)
      redirect_to subscription_path(@subscription_detail.subscription), notice: "Payment of INR #{ params[:subscription_detail][:last_payment_received] } successfully delivered"
    else
      render({ action: :receive_payment }, alert: "Payment could not be made. Errors: @subscription_detail.errors.full_messages.join('. ')")
    end
  end

  protected

    def load_subscription_detail
      @subscription_detail = SubscriptionDetail.find_by(id: params[:id])
      unless @subscription_detail.present?
        redirect_to(subscriptions_path, alert: 'No such subscription detail found: #' + params[:id])
      end
    end

    def check_already_dispatched
      if @subscription_detail.not_yet_dispatched?
        redirect_to :back, alert: 'Box is not yet dispatched'
      end
    end

    def check_not_already_delivered
      unless @subscription_detail.not_yet_delivered?
        redirect_to :back, alert: 'Box is already delivered'
      end
    end

    def check_not_already_payment_received
      unless @subscription_detail.payment_not_yet_received?
        redirect_to :back, alert: 'Box has already received payment'
      end
    end

    def check_already_delivered
      if @subscription_detail.not_yet_delivered?
        redirect_to :back, alert: 'Box is not yet delivered'
      end
    end

    def check_payment_greater_than_or_equal_to_zero
      if params[:subscription_detail][:last_payment_received].to_f < 0
        flash[:alert] = 'Payment should be greater than or equal to zero'
        render({ action: :receive_payment })
      end
    end

end
