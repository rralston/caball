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
    end
  end
  
  def show
    @user = User.find(params[:id])
    @projects = @user.projects
    @talents = @user.talents.offset(1)
    if @user.nil?
        redirect_to :action => :index
    end
    @search = User.search(params[:q])
    @users = @search.result
      if params[:q]
        redirect_to(:controller => :users, :action => :index, :q => params[:q]) and return
      end
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def new
     search
     @user = User.new
     @user.build_characteristics
     # @user.build_photos (this was building before save)
     @user.talent.build
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
     if @user.photos.first.nil?
       @user.photos.build
     end
     if @user.talents.nil?
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
     correct_user?
     @user = User.find(params[:id])
     respond_to do |format|
       if @user.update_attributes(params[:user])
         format.html { redirect_to @user, :notice => @user.name.pluralize + ' Profile was successfully updated.' }
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
       format.html { redirect_to Users_url }
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

