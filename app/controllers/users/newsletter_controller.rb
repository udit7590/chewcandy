class Users::NewsletterController < ::ApplicationController
  before_action :initialize_newsletter, only: :signup

  def signup
    redirect_to root_path, notice: 'Thank you for subscribing to our newsletter.'
  end

  protected

    def newsletter_params
    end

    def initialize_newsletter
    end

end
