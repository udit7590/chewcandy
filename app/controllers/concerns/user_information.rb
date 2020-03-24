module UserInformation
  extend ActiveSupport::Concern

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :same_as_billing_address,
      billing_address_attributes: [:full_address, :state, :city, :pincode, :country],
      shipping_address_attributes: [:full_address, :state, :city, :pincode, :country]
    ).merge(email_for_guest_user)
  end

  def email_for_guest_user
    @user.guest? ? params.require(:user).permit(:email) : {}
  end

  def check_same_shipping_address
    if params[:user][:same_as_billing_address]
      params[:user][:shipping_address] = params[:user][:billing_address]
    end
  end
end
