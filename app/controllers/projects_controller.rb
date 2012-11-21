class ProjectsController < ApplicationController

  def new
    @project = Project.new
  end

  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    
  end
  
  def edit
     # correct_project_owner?
     # Define Security Measures
     @project = Project.find(params[:id])
   end
   
   def create
     @project = Project.new(params[:user])
     respond_to do |format|
       if @project.save
         format.html { redirect_to @project, :notice => 'Project was successfully created.' }
       else
         format.html { render :action => "new" }
       end
     end
   end

   def update
     # correct_project_owner?
     # Define Security Measures
     @project = Project.find(params[:id])
     respond_to do |format|
       if @project.update_attributes(params[:user])
         format.html { redirect_to @user, :notice => @project.name + ' Project was successfully updated.' }
       else
         format.html { render :action => "edit", :error => 'Project was not created.' }
       end
     end
   end

   def destroy
     # correct_project_owner?
     # Define Security Measures
     @project = Project.find(params[:id])
     @project.destroy

     respond_to do |format|
       format.html { redirect_to Project_url }
     end
   end
end
