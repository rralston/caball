class Admin::AdminController < Admin::BaseController
  
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
  @users = User.all
  end
end

