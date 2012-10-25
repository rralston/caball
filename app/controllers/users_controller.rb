class UsersController < ApplicationController

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def new
     @user = User.new
     @user.build_characteristics
     respond_to do |format|
       format.html # new.html.erb
     end
   end

   def edit
     @user = User.find(params[:id])
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
     @user = User.find(params[:id])

     respond_to do |format|
       if @user.update_attributes(params[:user])
         format.html { redirect_to @user, :notice => @user.first_name.pluralize + ' Profile was successfully updated.' }
       else
         format.html { render :action => "edit", :error => 'User was successfully created.' }
       end
     end
   end

   def destroy
     @user = User.find(params[:id])
     @user.destroy

     respond_to do |format|
       format.html { redirect_to Users_url }
     end
   end  
end
