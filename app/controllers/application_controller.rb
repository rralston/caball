class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :subdomain_view_path
  helper_method :current_user
  # Security & Authentication
  helper_method :user_signed_in?
  helper_method :correct_user?
  private

  def subdomain_view_path
    prepend_view_path "app/views/#{request.subdomain}_subdomain" if request.subdomain.present?
  end
  
  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def user_signed_in?
      return true if current_user
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url, :alert => "Access denied."
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to new_user_url, :alert => 'You need to sign in for access to this page.'
    end
  end
end
