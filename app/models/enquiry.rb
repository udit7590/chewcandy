class Enquiry < ActiveRecord::Base
  belongs_to :user

  ABOUT = [
    'Availability',
    'Gifts',
    'Wedding Solutions',
    'Other'
  ]

  validate :about, :message, presence: true
  validate :from_name, :from_email, presence: true, unless: :user_present?

  after_create :mail_it

  private

    def user_present?
      user.present?
    end

    def user_name
      user.present? ? user.name : from_name
    end

    def user_email
      user.present? ? user.email : from_email
    end

    def mail_message
      " ABOUT: #{ about } \n MESSAGE: #{ message }"
    end

    def mail_it
      AdminMailer.customer_feedback(User.admin_ids, user_name, user_email, mail_message).deliver
    end
end
