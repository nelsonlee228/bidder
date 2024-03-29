class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user #linked to all views

  def authenticate_user!
    redirect_to login_path, alert: "You need to sign in" if current_user.nil?
  end

end
