class Users::RegistrationsController < ::Devise::RegistrationsController
  layout 'user'
  respond_to :html, :json

  before_action :configure_sign_up_parameters, if: :devise_controller?
  after_action :transfer_guest_user_cart, if: -> { session[:guest_user_id].present? }

  def create
    build_resource(sign_up_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      set_flash_message :notice, :signed_up
      sign_in(resource_name, resource)
      @redirect_to_path = request.referer
      session[:registered] = true

      respond_to do |format|
        format.js { render 'users/registrations/success' }
      end
    else
      # Errors occurred while registration
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      
      @minimum_password_length = resource_class.password_length.min if @validatable

      respond_to do |format|
        format.js { render 'users/registrations/error' }
      end
    end
  end

  protected
  
    def configure_sign_up_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone_number) }
    end

    def after_update_path_for(resource)
      root_path
    end

    def transfer_guest_user_cart
      transfer_guest_user_records_to_logged_in_user(resource)
    end

end
