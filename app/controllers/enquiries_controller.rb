class EnquiriesController < ApplicationController

  def create
    @enquiry = Enquiry.new(enquiry_params)
    if @enquiry.save
      render 'success_enquiry'
    else
      render js: 'alert("Unable to receive your enquiry. Please ensure all fields are filled.")'
    end
  end

  private
    def enquiry_params
      if @user.guest?
        params.require(:enquiry).permit(:about, :message, :from_name, :from_email)
      else
        params.require(:enquiry).permit(:about, :message).merge(user_id: @user.id)
      end
    end
end
