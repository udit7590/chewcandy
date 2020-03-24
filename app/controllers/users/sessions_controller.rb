class Users::SessionsController < ::Devise::SessionsController

  def create
    resource = warden.authenticate!(scope: resource_name, recall: 'users/sessions#failure')
    sign_in_and_redirect(resource_name, resource)
  end
 
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    @redirect_to_path = request.referer
    set_flash_message :notice, :signed_in
    respond_to do |format|
      format.js { render 'users/sessions/login' }
      format.html { redirect_to after_sign_in_path_for(resource) }
    end
  end
 
  def failure
    render 'users/sessions/error_login', locals: { user_confirmed: true }
  end

  protected
    def after_sign_in_path_for(resource)
      session[:previous_url] || root_path
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
