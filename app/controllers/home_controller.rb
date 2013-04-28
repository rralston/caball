class HomeController < ApplicationController
  before_filter :search
  
  def index
    @projects = Project.find(1, 2, 3)
    @users = User.find(1, 2, 3) # Super simple "Featured projects/users" selection
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
