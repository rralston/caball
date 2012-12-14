class UsersController < ApplicationController

  #Security & Authentication Checker
  # before_filter :authenticate_user!
  # before_filter :correct_user?
  
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @user = User.find(params[:id])
    @projects = @user.projects
    if @user.nil?
        redirect_to :action => :index
    end
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def new
     @user = User.new
     @user.build_characteristics
     @user.build_photo
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
     if @user.photo.nil?
       @user.photo = Photo.new
     end
    @user.talents.build
 end
   
   def create
     @user = User.new(params[:user])
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
         format.html { redirect_to @user, :notice => @user.name + ' Profile was successfully updated.' }
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
end

