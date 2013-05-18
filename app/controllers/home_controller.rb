class HomeController < ApplicationController
  before_filter :search
  
  def index
    @projects = Project.where(:featured => true).first(3)
    @users = User.where(:featured => true).first(3)
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.friend_ids, owner_type: "User")
  end

  def about
  end
  
  def privacy
  end
  
  def terms
  end
  
  def contact
  end
  
  def blog
  end
end
