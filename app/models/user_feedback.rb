class UserFeedback
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :user_name, :user_email, :feedback, :type

  def initialize(attrs = {})
    @user_name  = attrs[:user_name]
    @user_email = attrs[:user_email]
    @feedback   = attrs[:feedback]
    @type       = attrs[:type]
  end

  def mail_it
    AdminMailer.customer_feedback(User.admin_ids, user_name, user_email, feedback).deliver
  end

end
