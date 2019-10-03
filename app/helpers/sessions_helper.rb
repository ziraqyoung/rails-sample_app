module SessionsHelper
  # logs in a given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns current logged in use, if any
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Return true if a given user is the current user
  def current_user?(user)
    user == current_user
  end

  # Remember a user in persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forget a user
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logout current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Return true if the user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Redirected to the stored location ( or to the default )
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the url tried to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
