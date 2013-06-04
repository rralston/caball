class UsersController < ApplicationController

  #Security & Authentication Checker
  # before_filter :authenticate_user!
  # before_filter :correct_user?
  
  def index
    @search = User.search(params[:q])
    @users = @search.result
    @search.build_condition
    user_fields
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
    @user = User.find(params[:id])
    @blog = Blog.new
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
    
    @followers_following = Array.new
    
    Friendship.where(:friend_id => @user.id).each do |friendship|
      @followers_following.push(User.find(friendship.user_id)) unless @followers_following.include?(User.find(friendship.user_id))
    end 
    @user.friendships.all.each do |friendship|
      @followers_following.push(User.find(friendship.user_id)) unless @followers_following.include?(User.find(friendship.user_id))
    end
    
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
  
  def new
     search
     @user = User.new
     @user.build_characteristics
     @user.build_profiles
     # @user.build_photos (this was building before save)
     # @user.talents.build
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
     user_fields
     @videos = @user.videos
     # unless @videos.first.present?
     #   3.times do
     #     @videos.build
     #    end
     # end
     if @user.profiles.nil?
       @user.build_profiles
     end
     unless @user.talents.exists?
       @user.talents.build
       @user.talents.build 
     end
     # if @user.talents.second.nil?
     #   @user.talents.second.build
     # end
 end
   
   def create
     @user = User.new(params[:user])
     # if @user.photos.empty?
     #   @user.photos.destroy
     # end
     respond_to do |format|
       if @user.save
         UserMailer.signup_confirmation(@user).deliver
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
     search
     correct_user?
     @user = User.find(params[:id])
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
     rescue ActiveRecord::RecordNotFound
          redirect_to :action => 'show'
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
  
  def user_fields
     @talents = {'Actor' => 'Actor', 'Producer' => 'Producer', 'Director' => 'Director', 'Technical' => 'Technical', 'Stuntmen' => 'Stuntmen', 'Fan' => 'Fan', 'Talent Manager' => 'Talent Manager'}
  end
end

