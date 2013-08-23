class HomeController < ApplicationController
  before_filter :search
  
  def index
    @projects = Project.where(:featured => true).first(3)
    @users = User.where(:featured => true).first(3)
    if current_user.present?
      redirect_to '/dashboard'
    end
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
