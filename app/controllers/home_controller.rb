class HomeController < ApplicationController
  
  def index
    search
  end

  def about
    search
  end
  
  def privacy
    search
  end
  
  def terms
    search
  end
  
  def contact
    search
  end
  
  def blog
    search
  end
  
  def search
    @search = User.search(params[:q])
    @users = @search.result
    if params[:q]
      redirect_to :controller => :users, :action => :index, :q => params[:q]
    end
  end
end
