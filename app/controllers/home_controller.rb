class HomeController < ApplicationController
  before_filter :search
  
  def index
    @projects = Project.limit(3)
    @users = User.limit(3) # Super simple "Featured projects/users" selection
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
