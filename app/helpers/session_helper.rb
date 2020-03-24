module SessionHelper
  def anybody_logged_in?
    !!current_user
  end

  def nobody_logged_in?
    !anybody_logged_in?
  end
end
