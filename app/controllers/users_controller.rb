class UsersController < ApplicationController

  #Security & Authentication Checker
  # before_filter :authenticate_user!
  # before_filter :correct_user?
  
  def index
    @search = User.search(params[:q])
    @users = @search.result
    @search.build_condition
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {
                   :success => true, 
                   :html => render_to_string(:partial => 'user_search_results', 
                                             :layout => false, :formats => [:html], :locals => {} ) 
                  } }
    end
  end
  
  def show
    @user = User.find(params[:id])
    @projects = @user.projects
    @talents = @user.talents
    if @user.nil?
        redirect_to :action => :index
    end
    @search = User.search(params[:q])
    @users = @search.result
    if params[:q]
      redirect_to(:controller => :users, :action => :index, :q => params[:q]) and return
    end
      
    @real_videos = Array.new
    for video in @user.videos
      if video.thumbnail_small.present?
        @real_videos << video
      end
    end
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def new
     search
     @user = User.new
     @user.build_characteristics
     @user.build_profiles
     # @user.build_photos (this was building before save)
     # @user.talents.build
     3.times do 
       @video = @user.videos.build
     end
     respond_to do |format|
       format.html # new.html.erb
     end
   end

   def edit
     correct_user?
     search
     @user = User.find(params[:id])
     if @user.characteristics.nil?
        @user.build_characteristics
      end
     @videos = @user.videos
     if @videos.first.nil?
       @videos.build
     end
     if @videos.second.nil?
       @videos.build
     end
     if @videos.third.nil?
       @videos.build
     end
     if @user.profiles.nil?
       @user.build_profiles
     end
     if @user.talents.first.nil?
       @user.talents.build
     end
     if @user.talents.second.nil?
       @user.talents.build
     end
 end
   
   def create
     @user = User.new(params[:user])
     # if @user.photos.empty?
     #   @user.photos.destroy
     # end
     respond_to do |format|
       if @user.save
         format.html { redirect_to @user, :notice => 'User was successfully created.' }
       else
         format.html { render :action => "new" }
       end
     end
   end

   def update
     search
     correct_user?
     @user = User.find(params[:id])
     respond_to do |format|
       if @user.update_attributes(params[:user])
         format.html { redirect_to @user, :notice => @user.name.possessive + ' Profile was successfully updated.' }
       else
         format.html { render :action => "edit", :error => 'User was successfully created.' }
       end
     end
   end

   def destroy
     correct_user?
     @user = User.find(params[:id])
     @user.destroy
     respond_to do |format|
       format.html { redirect_to root_url, :notice => 'Sorry to see you leave :-(' }
     end
   end  
   
  def search
   @search = User.search(params[:q])
   @users = @search.result
     if params[:q]
       redirect_to(:controller => :users, :action => :index, :q => params[:q]) and return   
     end
  end
end

