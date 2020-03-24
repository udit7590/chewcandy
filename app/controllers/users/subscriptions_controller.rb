class Users::SubscriptionsController < ::ApplicationController
  layout 'user'
  before_action :authenticate_user!
  before_action :load_subscription, only: [:show, :cancel]
  before_action :check_subscription_active, only: :cancel
  before_action :check_reason_provided, only: :cancel

  def index
    @subscriptions = @user.subscriptions
    @past_subscriptions = @user.past_subscriptions
  end

  def show
  end

  def cancel
    if @subscription.cancel(@cancel_reason)
      redirect_to users_subscription_path(@subscription), notice: 'Your subscription has been cancelled'
    else
      error_msg = "Unable to cancel your subscription:<br />"
      error_msg += @subscription.errors.full_messages.join('<br />') if @subscription.errors.present?
      flash[:alert] =  error_msg.html_safe
      render({ action: :show })
    end
  end

  protected

    def load_subscription
      @subscription = Subscription.find_by(id: params[:id])
      unless @subscription
        redirect_to root_path, alert: 'Cannot find any such subscription'
      end
    end

    def check_subscription_active
      unless @subscription.active?
        redirect_to users_subscription_path(@subscription), alert: 'This subscription is no longer active'
      end
    end

    def check_reason_provided
      @cancel_reason = params[:subscription][:cancel_reason].to_s.strip
      unless @cancel_reason.present?
        redirect_to users_subscription_path(@subscription), alert: 'Please provide the reason for your cancellation'
      end
    end

end
