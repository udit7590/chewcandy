class SubscriptionsController < ApplicationController
  layout :orders_layout
  include UserInformation

  before_action :authenticate_user!, except: [:new, :create]
  before_action :check_admin, except: [:new, :create]
  before_action :verify_actions_for_filter, only: :filter
  before_action :load_subscription, only: [:show, :dispatch_box]
  before_action :load_plan, only: [:new, :create]
  before_action :validate_plan, only: [:new, :create]
  before_action :check_subscription_active, only: [:dispatch_box]
  before_action :check_same_shipping_address, only: :create
  before_action :create_or_update_user, only: :create
  before_action :check_not_already_dispatched, only: :dispatch_box

  def index
    @subscriptions = Subscription.order(created_at: :desc).page(params[:page])
  end

  def filter
    @subscriptions = Subscription.send(params[:by]).order(created_at: :desc).page(params[:page])
    render :index
  end

  def show
  end

  def destroy
  end

  def new
  end

  def create
    @subscription = @user.subscriptions.build(plan_id: @plan.id)
    if @subscription.save
      redirect_to root_path, notice: "Your subscription has been successfully created. You have chosen #{ @plan.type.humanize } plan."
    else
      flash[:alert] = 'Unable to create your subscription.'
      render({ action: :new })
    end
  end

  def dispatch_box
    if @subscription.dispatch
      redirect_to(subscription_path(@subscription), notice: "Box is dispatched successfully at #{ @subscription.last_dispatch_date.to_s(:long) }. Expected payment: INR #{ @subscription.remaining_amount_to_be_collected }")
    else
      render({ action: :show }, alert: "Couldn't dispatch box. Error(s): #{ @subscription.error.full_messages.join('. ')}")
    end
  end

  protected

    def verify_actions_for_filter
      valid_filters = [:current_month_deliveries, :pending_payments, :pending_deliveries, :active, :cancelled_ones, :completed_ones]
      unless valid_filters.include?(params[:by].to_sym)
        redirect_to subscriptions_path, alert: 'Invalid Filter'
      end
    end

    def orders_layout
      admin_actions = ['index', 'show', 'filter']
      (@user.admin? && admin_actions.include?(action_name.to_s)) ? 'admin' : 'user'
    end

    def load_subscription
      @subscription = Subscription.find_by(id: (params[:subscription_id] || params[:id]))
      unless @subscription.present?
        redirect_to({ action: :index }, alert: 'No such subscription found')
      end
    end

    def load_plan
      @plan = Plan.find_by(id: params[:plan_id].to_i)
      unless @plan
        redirect_to root_path, alert: 'No such plan exists'
      end
    end

    def validate_plan
      unless Plan.find_by(id: params[:plan_id].to_i).active?
        redirect_to root_path, alert: 'This plan is no longer active'
      end
    end

    def create_or_update_user
      unless @user.update(user_params)
        render({ action: :new }, alert: 'Please make sure your details are valid')
      end
    end

    def initialize_subscription
      @subscription = @user.build_subscription(active: true, plan_id: @plan.id)
    end

    def check_not_already_dispatched
      if @subscription.box_dispatched_for_current_month?
        redirect_to(subscription_path(@subscription), alert: 'Box already dispatched for this month')
      end
    end

    def check_subscription_active
      unless @subscription.active?
        redirect_to(subscription_path(@subscription), alert: "This subscription plan(#{ @subscription.id }) is not active")
      end
    end

end
