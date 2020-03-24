class ApplicationController < ActionController::Base
  include GuestUser
  before_action :initialize_user
  before_action :load_cart
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def new_user_session_path
    '#login'
  end

  protected

    def initialize_user
      @user = current_or_guest_user
    end

    def load_cart
      @cart = @user.shopping_cart || ShoppingCart.find_by(id: session[:cart_id])
      if @cart.nil? || @cart.inactive?
        if @user.shopping_cart.present?
          @cart = @user.shopping_cart
        else
          @cart = ShoppingCart.create!(user_id: @user.id, active: true)
          session[:cart_id] = @cart.id
        end
      end
    end

    def check_admin
      unless @user.admin?
        redirect_to root_path, alert: 'You dont have permissions to access this section'
      end
    end

    def load_user
      @user = current_user
    end
end
