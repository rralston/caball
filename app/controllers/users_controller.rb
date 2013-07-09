class UsersController < ApplicationController

  load_and_authorize_resource :except => [:dashboard]
  before_filter :search, only: [:index, :show, :new, :edit, :update]
  
  def index
    @talents = User.types
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {
                   :success => true, 
                   :html => render_to_string(:partial => '/users/user_search_results.html.erb', 
                                             :layout => false, :formats => [:html], :locals => {} ) 
                  } }
    end
  end
  
  def show
    @blog = Blog.new
    @real_videos = @user.videos.real
    @followers_following = (@user.friends + @user.inverse_friends).uniq
    if params[:link]
      partial = params[:link]
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => {
                   :success => true, 
                   :html => render_to_string(:partial => partial, 
                                             :layout => false, :formats => [:html], :locals => {} ) 
                  } }
    end
  end
  
  ## ALERT : is this being used?
  def new
    @user.build_characteristics
    @user.build_profile
  end

  def edit
    @talents = User.types
    @videos = @user.videos
    @user.talents.present? || [@user.talents.build, @user.talents.build]
  end
   
  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => {
                      :success => true, 
                      :notice => 'User\'s info was saved' 
                    } }
      else
        format.html { render :action => "new" }
        format.json { render :json => {
                      :success => true, 
                      :notice => 'User\'s info was saved' 
                    } }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => @user.name.possessive + ' Profile was successfully updated.' }
        format.json { render :json => {
                        :success => true, 
                        :notice => 'User\'s info was saved' 
                      } }
      else
        format.html { render :action => "edit", :error => 'User was successfully created.' }
        format.json { render :json => {
                        :success => true, 
                        :notice => 'User\'s info was saved' 
                      } }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, :notice => 'Sorry to see you leave :-(' }
    end
  end

  def dashboard
    search
    @user = current_user
    render :template => 'dashboard/index'
  end


end