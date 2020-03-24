class OrdersController < ApplicationController
  layout :orders_layout
  include UserInformation

  before_action :authenticate_user!, except: [:checkout, :place, :check_coupon]
  before_action :check_admin, except: [:checkout, :place, :check_coupon]
  before_action :check_minimum_quantity, only: [:checkout, :place]
  before_action :verify_actions_for_filter, only: :filter
  before_action :load_order, only: [:show, :change_state]
  before_action :validate_cart, only: :place
  before_action :check_same_shipping_address, only: :place
  before_action :check_user_does_not_exist_already, only: :place, if: -> { @user.guest? }
  before_action :create_or_update_user, only: :place
  before_action :check_valid_action, only: :change_state
  before_action :check_allowed_action, only: :change_state

  def index
    @orders = Order.order(created_at: :desc).page(params[:page])
  end

  def filter
    @orders = Order.send(params[:by]).order(created_at: :desc).page(params[:page])
    render :index
  end

  def show
  end

  def destroy
  end

  def checkout
    session[:initiate_checkout] = true
  end

  def change_state
    if @order.send(@state_action.to_s + '!')
      redirect_to({action: :show}, notice: "Order moved to #{ @order.state } state")
    else
      render({action: :show}, notice: "Unable to trigger #{ @state_action } action on this order")
    end
  end

  def place
    @order = @user.orders.build(shopping_cart_id: params[:user][:shopping_cart_id].to_i)
    @order.build_from_cart
    if @order.save
      session[:cart_id] = nil
      session[:order_placed] = @order.net_amount
      redirect_to root_path, notice: 'Your order has been successfully placed.'
    else
      render({ action: :checkout }, alert: 'Unable to place your order. Make sure your cart is valid')
    end
  end

  def check_coupon
    @coupon = Coupon.new(params[:coupon_code], @cart)
    if @coupon.applicable?
      @cart.update(coupon_code: params[:coupon_code])
      render 'valid_coupon'
    else
      @cart.update(coupon_code: nil)
      render 'invalid_coupon'
    end
  end

  protected

    def check_minimum_quantity
      result = @cart.valid_for_checkout?
      unless @cart.valid_for_checkout?
        redirect_to root_path, alert: @cart.errors[:base].first
      end
    end

    def verify_actions_for_filter
      valid_filters = [:placed, :dispatched, :delievered, :cancelled, :payment_received, :refunded, :unscoped]
      unless valid_filters.include?(params[:by].to_sym)
        redirect_to orders_path, alert: 'Invalid Filter'
      end
    end

    def orders_layout
      admin_actions = ['index', 'show', 'filter']
      (@user.admin? && admin_actions.include?(action_name.to_s)) ? 'admin' : 'user'
    end

    def load_order
      @order = Order.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to({ action: :index }, alert: 'Cannot find any such order')
    end

    def validate_cart
      if params[:user][:shopping_cart_id].to_i != @cart.try(:id)
        redirect_to root_path, alert: 'Your cart is invalid. Please try again'
      end
    end

    def check_user_does_not_exist_already
      if User.find_by(email: params[:user][:email])
        @user.assign_attributes(user_params)
        flash[:error] = "You need to log in first to proceed checking out with email: #{ params[:user][:email] }."
        redirect_to(checkout_orders_path + '#login')
      end
    end

    def create_or_update_user
      unless @user.update(user_params)
        render(checkout_orders_path, alert: 'Please make sure your details are valid')
      end
    end

    def check_valid_action
      @state_action = params[:new_state].to_sym
      unless Order.events.include? @state_action
        redirect_to order_path(@order), alert: 'No such action'
      end
    end

    def check_allowed_action
      unless @order.allowed_actions.include? @state_action
        redirect_to order_path(@order), alert: 'This action is not applicable on current state'
      end
    end
end
