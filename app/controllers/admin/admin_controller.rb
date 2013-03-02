class Admin::AdminController < Admin::BaseController
  
  #Sign-In Check
  helper_method :current_user
  before_filter :user_signed_in?
  #Admin Status Check
  before_filter :require_admin
  
  # Search
  helper_method :search
   
  def index
    @users = User.all.count
    @users_weekly = User.where('created_at >= ?', 1.week.ago).count
    @users_2weeks = User.where('created_at >= ?', 2.week.ago).count - @users_weekly
    @users_3weeks = User.where('created_at >= ?', 3.week.ago).count - @users_2weeks
    @users_4weeks = User.where('created_at >= ?', 4.week.ago).count - @users_3weeks
    @percentage = @users_weekly-@users_2weeks
    @projects = Project.all.count
    @projects_weekly = Project.where('created_at >= ?', 1.week.ago).count
    @projects_2weeks = Project.where('created_at >= ?', 2.week.ago).count - @projects_weekly
    @projects_3weeks = Project.where('created_at >= ?', 3.week.ago).count - @projects_2weeks
    @projects_4weeks = Project.where('created_at >= ?', 4.week.ago).count - @projects_3weeks
    @recent_users = User.order('created_at DESC').last(10)
    @recent_projects = Project.order('created_at DESC').last(10)
    @conversations_weekly = Conversation.where('created_at >= ?', 1.week.ago).count
  end
  def users
    @count = User.all.count
    # @users = User.order("name").page(params[:page]).per(10)
    @search = User.search(params[:q])
    @users = @search.result.order("name").page(params[:page]).per(10)
  end
  def user_images
    @count = Photo.where('imageable_type = ? AND image = ?', "User", "Profile_Image.jpg").count
    @search = Photo.where('imageable_type = ? AND image = ?', "User", "Profile_Image.jpg").search(params[:q])
    @photos = @search.result.order("id").page(params[:page]).per(20)
  end
  def interrogate
    @user = User.find(params[:id])
    @projects = @user.projects
    @talents = @user.talents.offset(1)
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  def projects
    @count = Project.all.count
    # @projects = Project.order("title").page(params[:page]).per(10)
    @search = Project.search(params[:q])
    @projects = @search.result.order("title").page(params[:page]).per(10)
  end
  def project_images
    @count = Photo.where('imageable_type = ? AND image = ?', "Project", "Profile_Image.jpg").count
    @search = Photo.where('imageable_type = ? AND image = ?', "Project", "Profile_Image.jpg").search(params[:q])
    @photos = @search.result.order("id").page(params[:page]).per(20)
  end
  def messages
    @count = Notification.all.count
    @search = Notification.search(params[:q])
    @notification = @search.result.order("subject").page(params[:page]).per(10)
    # @notification = Notification.order("subject").page(params[:page]).per(10)
  end
  
  private
  def current_user
       @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def user_signed_in?
      unless current_user
      redirect_to root_url, :notice => 'Please sign-in.'
  end
  end
  def require_admin
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    unless @current_user.admin == true
      redirect_to root_url, :notice => 'Access denied.'
    end
  end
end

