class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      redirect_to root_path
      flash[:danger] = "You need to log in to do that!"
    end
  end
end
