class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def check
    if current_user
      @user_name = current_user.name
    else
      redirect_to root_url
    end
  end
  
  private
    def current_user
    # if current_user is nil then set it if the session exists
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user
end
