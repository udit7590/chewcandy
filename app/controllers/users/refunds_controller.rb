class Users::RefundsController < ::ApplicationController
  layout 'user'
  before_action :authenticate_user!
  before_action :load_order, only: :create
  before_action :initialize_refund, only: :create
  before_action :check_order_refundable, only: :create
  before_action :check_delivery_not_older_than_certain_date, only: :create

  def index
    @refunds = @user.refunds.active
    @inactive_refunds = @user.completed_refunds
  end

  # Not in use
  def create
    if @refund.create
      redirect_to root_path, notice: 'The refund has been initiated'
    else
      redirect_to root_path, alert: 'Coudn\'t initiate the refund. Please check if your order/subscription meets the refund criteria.'
    end
  end

  protected

    def load_order
      @order = Order.find_by(id: params[:id])
      unless @order
        redirect_to root_path, alert: 'Cannot find any such order'
      end
    end

    def initialize_refund
      @refund = Refund.new(order_id: params[:order_id], subscription_id: params[:subscription_id], comments: params[:comments])
    end

    def check_order_refundable
      unless @order.refundable_state?
        redirect_to users_order_path(@order), alert: 'Your order has not yet been dispatched and can\'t be refunded. Try cancelling your order'
      end
    end

    def check_delivery_not_older_than_certain_date
      unless @order.within_allowed_duration?
        redirect_to users_order_path(@order), alert: 'Your order can\'t be refunded now as your order is more than one week old'
      end
    end

end
