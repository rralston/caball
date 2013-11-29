class Admin::AdminController < Admin::BaseController
  before_filter :require_admin

  include Admin::AdminHelper
  
  def index
    # users analysis
    @users = User.all
    @users_count = @users.count
    @users_weekly = objects_created_within_date_range(@users, 1.week.ago, Time.now).count
    @users_2weeks = objects_created_within_date_range(@users, 2.week.ago, 1.week.ago).count
    @users_3weeks = objects_created_within_date_range(@users, 3.week.ago, 2.week.ago).count
    @users_4weeks = objects_created_within_date_range(@users, 4.week.ago, 3.week.ago).count
    @percentage = @users_weekly - @users_2weeks
    @recent_users = User.order('created_at DESC').last(10)
    # project analysis
    @projects = Project.all
    @projects_count = @projects.count
    @projects_weekly = objects_created_within_date_range(@projects, 1.week.ago, Time.now).count
    @projects_2weeks = objects_created_within_date_range(@projects, 2.week.ago, 1.week.ago).count
    @projects_3weeks = objects_created_within_date_range(@projects, 3.week.ago, 2.week.ago).count
    @projects_4weeks = objects_created_within_date_range(@projects, 4.week.ago, 3.week.ago).count
    @recent_projects = Project.order('created_at DESC').last(10)
    #Events analysis
    @events = Event.all
    @events_count = @events.count
    @events_weekly = objects_created_within_date_range(@events, 1.week.ago, Time.now).count
    # conversation analysis
    @conversations_weekly = objects_created_within_date_range(Conversation.all, 1.week.ago, Time.now).count
  end

  def users
    @count = User.all.count
    # @users = User.order("name").page(params[:page]).per(10)
    @search = User.search(params[:q])
    # @users = @search.result.order("name").page(params[:page]).per(10)
    # Kaminari.paginate_array(users).per_page_kaminari(page).per(per_page)
    @users = @search.result.order("name").per_page_kaminari(params[:page]).per(10)
    
  end

  def update_user
    user = User.find(params[:user_id])
    user.admin = params[:user][:admin] if current_user.admin?
    if user.update_attributes( params[:user] )
      render js: 'alert("User details updated.")' 
    else
      render js: "alert('Failed to updated. Errors: #{user.errors.full_messages.first}')"
    end
    
  end

  def user_images
    # @count = Photo.where('imageable_type = ? AND image = ?', "User", "Profile_Image.jpg").count
    @count = Photo.where('imageable_type = ?', "User").count
    @search = Photo.where('imageable_type = ?', "User").search(params[:q])
    @photos = @search.result.order("id").per_page_kaminari(params[:page]).per(20)
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
    @projects = @search.result.order("title").per_page_kaminari(params[:page]).per(10)
  end

  def update_project
    project = Project.find(params[:project_id])
    
    if project.update_attributes( params[:project] )
      render js: 'alert("Project details updated.")' 
    else
      render js: "alert('Failed to updated. Errors: #{project.errors.full_messages.first}')"
    end
    
  end

  def project_images
    # @count = Photo.where('imageable_type = ? AND image = ?', "Project", "Profile_Image.jpg").count
    Photo.where('imageable_type = ?', "Project").count
    @search = Photo.where('imageable_type = ?', "Project").search(params[:q])
    @photos = @search.result.order("id").per_page_kaminari(params[:page]).per(20)
  end
  
  def events
    @count = Event.all.count
    @search = Event.search(params[:q])
    @events = @search.result.order("title").per_page_kaminari(params[:page]).per(10)
  end
  
  def event_images
    Photo.where('imageable_type = ?', "Event").count
    @search = Photo.where('imageable_type = ?', "Event").search(params[:q])
    @photos = @search.result.order("id").per_page_kaminari(params[:page]).per(20)
  end

  def messages
    @count = Notification.all.count
    @search = Notification.search(params[:q])
    @notification = @search.result.order("subject").per_page_kaminari(params[:page]).per(10)
    # @notification = Notification.order("subject").page(params[:page]).per(10)
  end
  
  private
 
  def require_admin
    if current_user.admin != true
        redirect_to root_url, :flash => { :error => "Access denied." }
    end
  end

end
