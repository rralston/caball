class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :subdomain_view_path

  private

  def subdomain_view_path
    prepend_view_path "app/views/#{request.subdomain}_subdomain" if request.subdomain.present?
  end
  
  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
