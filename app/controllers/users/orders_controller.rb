class Users::OrdersController < ::ApplicationController
  layout 'user'
  before_action :authenticate_user!
  before_action :load_order, only: [:show, :cancel, :refund]
  before_action :check_order_in_placed_state, only: :cancel
  before_action :check_order_refundable, only: :refund
  before_action :check_delivery_not_older_than_certain_date, only: :refund
  before_action :check_reason_provided, only: :refund

  def index
    @orders = @user.orders.placed
    @dispatched_orders = @user.orders.dispatched
    @past_orders = @user.orders.past
  end

  def show
    pdf = ::OrderInvoicePDF.new(@order)
    respond_to do |format|
      format.pdf { send_data pdf.render, filename: 'invoice.pdf', type: 'application/pdf', disposition: 'inline' }
      format.html { render :show }
    end
  end

  def cancel
    if @order.cancel!
      redirect_to users_order_path(@order), notice: 'Your order has been cancelled'
    else
      redirect_to users_order_path(@order), alert: 'Coudn\'t cancel your order. Please check if your order meets the cancellation criteria.'
    end
  end

  # Not in use
  def refund
    if @order.initiate_refund!
      redirect_to users_order_path(@order), notice: 'The refund process for your order has been initiated'
    else
      redirect_to users_order_path(@order), alert: 'Coudn\'t initiate the refund for your order. Please check if your order meets the refund criteria.'
    end
  end

  protected

    def load_order
      @order = Order.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_path, alert: 'Cannot find any such order')
    end

    def check_order_in_placed_state
      unless @order.placed?
        redirect_to users_order_path(@order), alert: 'Your order has already been dispatched and can\'t be cancelled now'
      end
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

    def check_reason_provided
      @order.refund_reason = params[:order][:refund_reason].to_s.strip
      unless @order.refund_reason.present?
        redirect_to users_order_path(@order), alert: 'Please provide the reason for your refund'
      end
    end

end
