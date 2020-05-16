class UserMailer < ApplicationMailer
  layout 'user_email'

  default from: 'orders-chewcandy@booleans.in'

  def notify_user_registrered(user_id)
    @user = User.find_by(id: user_id)
    return nil unless @user

    mail(to: @user.email, from: 'orders-chewcandy@booleans.in', subject: 'Welcome to Chew Candy. Best place to satiate your crave for candies.')
  end

  def notify_user_about_order_state_change(user_id, order_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @order = Order.find_by(id: order_id)
    return nil unless @order

    mail(to: @user.email, subject: 'Your order has moved ahead in the process.')
  end

  def notify_user_about_order_placed(user_id, order_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @order = Order.find_by(id: order_id)
    return nil unless @order

    attachments['order_invoice.pdf'] = generate_order_invoice_pdf(@order)
    mail(to: @user.email, subject: "Your order ID: #{ @order.identifier }. ChewCandy will soon dispatch your order.")
  end

  def notify_user_about_subscription(user_id, subscription_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @subscription = Subscription.find_by(id: subscription_id)
    return nil unless @subscription

    attachments['subscription_invoice.pdf'] = generate_subscription_invoice_pdf(@subscription)
    mail(to: @user.email, subject: 'Chew Candy has received your request for subscription.')
  end

  protected

    def generate_order_invoice_pdf(order)
      OrderInvoicePDF.new(order).render
    end

    def generate_subscription_invoice_pdf(subscription)
      SubscriptionInvoicePDF.new(subscription).render
    end
end
