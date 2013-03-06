class ProjectsController < ApplicationController
  
  # Search
  helper_method :search
  
  def index
    @search = Project.search(params[:q])
    @projects = @search.result
    @search.build_condition
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    search
    @project = Project.find(params[:id])
    
    if @project.nil?
        redirect_to :action => :index
    end
    
    @real_videos = Array.new
    for video in @project.videos
      if video.thumbnail_small.present?
        @real_videos << video
      end
    end
  end
  
  def edit
     # correct_project_owner?
     # Define Security Measures
     search
     @talents = {'Actor / Actress' => 1, 'Animators' => 2, 'Art' => 3, 'Audio' => 4, 'Casting Director' => 5, 'Cinematographer / DP' =>6, 'Composer' => 7, 'Costumes' => 8, 'Director' => 9, 'Distribution Professional' => 10, 'Editor' => 11, 'Executive Producer' => 12, 'Hairstylist / Makeup Artist' => 13, 'Lighting / Electrical' => 14, 'Other' => 15, 'Personal Assistant' => 16, 'Producer' => 17, 'Production Staff' => 18, 'Props' => 19, 'Set Design' => 20, 'Sound' => 21, 'Stuntman' => 22, 'Talent Agent / Literary Agent' => 23, 'Talent Manager' => 24, 'Visual Effects' => 25, 'Writer' => 26}
     @project = Project.find(params[:id])
     @pictures = @project.photos
     if @pictures.first.nil?
       @pictures.build
     end
     if @pictures.second.nil?
       @pictures.build
     end
     if @pictures.third.nil?
       @pictures.build
     end
     @videos = @project.videos
      if @videos.first.nil?
        @videos.build
      end
  end
  
  def new
    search
    @talents = {'Actor / Actress' => 1, 'Animators' => 2, 'Art' => 3, 'Audio' => 4, 'Casting Director' => 5, 'Cinematographer / DP' =>6, 'Composer' => 7, 'Costumes' => 8, 'Director' => 9, 'Distribution Professional' => 10, 'Editor' => 11, 'Executive Producer' => 12, 'Hairstylist / Makeup Artist' => 13, 'Lighting / Electrical' => 14, 'Other' => 15, 'Personal Assistant' => 16, 'Producer' => 17, 'Production Staff' => 18, 'Props' => 19, 'Set Design' => 20, 'Sound' => 21, 'Stuntman' => 22, 'Talent Agent / Literary Agent' => 23, 'Talent Manager' => 24, 'Visual Effects' => 25, 'Writer' => 26}
    @project = Project.new
    @project.roles.build
    3.times do 
      @project.photos.build
    end
    3.times do 
      @video = @project.videos.build
    end
  end
  
 def create
   @project = Project.new(params[:project])
   @project.user_id = current_user.id
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
       if @project.update_attributes(params[:project])
         format.html { redirect_to @project, :notice => @project.title + ' Project was successfully updated.' }
       else
         format.html { render :action => "edit", :notice => 'Project was not created.' }
       end
     end
   end

   def destroy
     # correct_project_owner?
     # Define Security Measures
     @project = Project.find(params[:id])
     @project.destroy
     respond_to do |format|
       format.html { redirect_to root_url, :notice => @project.title + ' Project was deleted.' }
     end
   end
  
  def search
      @search = Project.search(params[:q])
      @projects = @search.result
      if params[:q]
        redirect_to :action => :index, :q => params[:q]
      end
    end
  end