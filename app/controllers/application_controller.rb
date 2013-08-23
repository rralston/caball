class ApplicationController < ActionController::Base
  #News Feed
  include PublicActivity::StoreController
  include RedirectHelper
  protect_from_forgery
  
  before_filter :subdomain_view_path
  # helper_method :current_user
  # hide_action :current_user
  helper_method :notification  
  helper_method :activities
  # Security & Authentication
  helper_method :user_signed_in?
  helper_method :correct_user?
  # Search
  helper_method :search

  rescue_from CanCan::AccessDenied do |exception|
    if request.xhr?
      render :text => false
    else
      redirect_to root_url, notice: "You are not authorized to access the page."
    end
  end


  def after_sign_up_path_for(user)
    edit_user_path(user)
  end

  def after_sign_in_path_for(user)
    '/dashboard'
  end

  def main_search
    query = params[:q]

    events   = Event.search_events(query)
    projects = Project.search_projects(query)
    users    = User.search_users(query)

    render :json => JSON.parse(users.to_json(:for_search => true)) + JSON.parse(projects.to_json(:for_search => true)) + JSON.parse(events.to_json(:for_search => true))
  end


  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  # helper_method :current_user
  

  def subdomain_view_path
    prepend_view_path "app/views/#{request.subdomain}_subdomain" if request.subdomain.present?
  end
  
  # Search for Home Directory
  def search(model=User, instance="users")
   @search = model.search(params[:q])
   instance_variable_set("@#{instance}", @search.result)
     if params[:q]
       redirect_to(:controller => :users, :action => :index, :q => params[:q]) and return
     end
  end
  
  # Project Comments System

  def require_login
    redirect_to login_url, alert: "You must first log in or sign up." if current_user.nil?
  end
  
  
  def activities
    if @current_user
      activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.friend_ids, owner_type: "User")
    end
  end
  
  #Notification System  
  def notification
    if @current_user
      notification = @current_user.receipts.is_unread.count
      notification if notification > 0
    end
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

  def report
    entity_class = params[:entity].camelize.constantize
    entity = entity_class.find(params[:id])
    message = params[:reason]
    UserMailer.report_entity_mail(current_user, entity, message).deliver
    render :text => true
  end
end
