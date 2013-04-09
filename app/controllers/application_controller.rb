class ApplicationController < ActionController::Base
  protect_from_forgery
  #News Feed
  include PublicActivity::StoreController
  before_filter :subdomain_view_path
  helper_method :current_user
  helper_method :notification
  # Security & Authentication
  helper_method :user_signed_in?
  helper_method :correct_user?
  # Search
  helper_method :search
  private

  def subdomain_view_path
    prepend_view_path "app/views/#{request.subdomain}_subdomain" if request.subdomain.present?
  end
  
  # Search for Home Directory
  def search
   @search = User.search(params[:q])
   @users = @search.result
     if params[:q]
       redirect_to(:controller => :users, :action => :index, :q => params[:q]) and return
     end
  end
  
  # Project Comments System
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def require_login
      redirect_to login_url, alert: "You must first log in or sign up." if current_user.nil?
    end
  
  #Notification System  
  def notification
    if @current_user
    notification = @current_user.receipts.where(:receiver_id == :user_id).is_unread.count
    if notification > 0
    notification
      end
    end
  end
  
  # Authentication
  
  def require_login
    redirect_to login_url, alert: "You must first log in or sign up." if current_user.nil?
  end
  
  def current_user
       @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
   
  def user_signed_in?
      return true if current_user
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user || @current_user.admin == true
      redirect_to root_url, :error => 'Access denied.'
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to new_user_url, :error => 'You need to sign in for access to this page.'
    end
  end
end
