class SessionsController < ApplicationController
  #Create session and send to continue sign-up process
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    if user.location.present?
      redirect_to user_url(session[:user_id]), {:notice => 'Welcome back to Caball, you are now signed in!'}
    else
      redirect_to edit_user_url(session[:user_id]), {:notice => 'Thanks for signing up! How about a few more details?'}
    end
  end
  #Destroy Session send to root defined in routes
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end