class AdminMailer < ApplicationMailer

  default from: 'orders@chewcandy.com'

  def order_received(admin_ids, user_id, order_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @order = Order.find_by(id: order_id)
    return nil unless @order
    @admins = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] We have received a new order')
  end

  def subscription_received(admin_ids, user_id, subscription_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @subscription = Subscription.find_by(id: subscription_id)
    return nil unless @subscription
    @admins = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] We have received a new subscription request')
  end

  def refund_initiated_by_user(admin_ids, user_id, order_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @order = Order.find_by(id: order_id)
    return nil unless @order
    @admins = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] A user has asked for refund.')
  end

  def order_cancelled_by_user(admin_ids, user_id, order_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @order = Order.find_by(id: order_id)
    return nil unless @order
    @admins = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] A user has cancelled an order.')
  end

  def subscription_cancelled_by_user(admin_ids, user_id, subscription_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @subscription = Subscription.find_by(id: subscription_id)
    return nil unless @subscription
    @admins = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] A user has cancelled his/her subscription.')
  end

  def customer_feedback(admin_ids, user_name, user_email, feedback)
    @user_name  = user_name
    @user_email = user_email
    @feedback   = feedback
    @admins     = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] We have received a new feedback from a customer')
  end

  def newsletter_signup(admin_ids, user_email)
    @user_name  = user_name
    @user_email = user_email
    @admins     = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] We have received a new feedback from a customer')
  end

  def customer_grievances(admin_ids, user_id)
    @user = User.find_by(id: user_id)
    return nil unless @user
    @admins = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[Chew Candy] We have received a new grievance from a customer')
  end

end
