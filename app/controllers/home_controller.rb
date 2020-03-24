class HomeController < ApplicationController
  layout :static_page_layout

  before_action :load_user, except: :heartbeat
  before_action :find_product_if_present_in_params, only: :index
  skip_before_action :initialize_user, only: :heartbeat
  skip_before_action :load_cart, only: :heartbeat

  def index
    @products = Product.all
  end

  def about_us
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def heartbeat
  end

  protected

    def static_page_layout
      return false if action_name.to_s == 'heartbeat'
      [:index].include?(action_name.to_sym) ? 'application' : 'user'
    end

    def load_user
      @user = current_or_guest_user
      unless @user
        raise 'Something went wrong'
      end
    end

    def find_product_if_present_in_params
      @product = Product.friendly.find(params[:candy_name]) if params[:candy_name].present?
    rescue ActiveRecord::RecordNotFound
      params.delete :candy_name
    end

end
