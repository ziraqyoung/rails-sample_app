module SessionsHelper
  # logs in a given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns current logged in use, if any
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) 
  end

  # Logout current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  # Return true if the user is logged in
  def logged_in?
    !current_user.nil?
  end
end
