class Users::FeedbacksController < ::ApplicationController
  before_action :initialize_feedback, only: :send_feedback

  def send_feedback
    @user_feedback.mail_it
    redirect_to root_path, notice: 'Thank you for your feedback.'
  end

  protected

    def feedback_params
      params.require(:user_feedback).permit(:user_name, :user_email, :feedback)
    end

    def initialize_feedback
      @user_feedback = UserFeedback.new(feedback_params)
    end

end
