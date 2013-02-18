class HomeController < ApplicationController
  
  def index
    @search = User.search(params[:q])
    @users = @search.result
    if params[:q]
      redirect_to :controller => :users, :action => :index, :q => params[:q]
    end
  end

  def about
  end
  
  def privacy
  end
  
  def terms
  end
  
end
