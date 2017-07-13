class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_userid(auth["provider"], auth["uid"])
    if user == nil
      user = User.create_from_omniauth(auth)
    end
    session[:user_id] = user.id
    redirect_to root_url, notice: "Signed in!"
  end
  
  def signout
  session[:user_id] = nil
  redirect_to root_url, notice: "You have signed out!"
  end
end
