class ProjectsController < ApplicationController
  
  # Search
  helper_method :search
  
  def index
    @search = Project.search(params[:q])
    @projects = @search.result
    @search.build_condition
    project_fields
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {
                   :success => true, 
                   :html => render_to_string(:partial => '/projects/project_search_results.html.erb', 
                                             :layout => false, :locals => {} ) 
                  } }
    end
  end
  
  def show
    search
    @project = Project.find(params[:id])
    @comment = Comment.new
    if @project.nil?
        redirect_to :action => :index
    end
    
    @producer = @project.user
    
    @real_videos = Array.new
    
    for video in @project.videos
      if video.thumbnail_small.present?
        @real_videos << video
      end
    end
    
    @sorted_roles = Hash.new
    
    @project.roles.each do |role|
      if @sorted_roles.has_key?(role.name) then
        @sorted_roles[role.name] << role
      else
        @sorted_roles[role.name] = [role]
      end
    end
  end
  
  def edit
     # correct_project_owner?
     # Define Security Measures
     search
     project_fields
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
    project_fields
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
        redirect_to(:controller => :users, :action => :index, :q => params[:q]) and return   
      end
    end
    
  def project_fields
     @talents = {'Actor / Actress' => 'Actor / Actress', 'Animators' => 'Animators', 'Art' => 'Art', 'Audio' => 'Audio', 
                'Casting Director' => 'Casting Director', 'Cinematographer / DP' => 'Cinematographer / DP', 'Composer' => 'Composer', 
                'Costumes' => 'Costumes', 'Director' => 'Director', 'Distribution Professional' => 'Distribution Professional', 
                'Editor' => 'Editor', 'Executive Producer' => 'Executive Producer', 'Hairstylist / Makeup Artist' => 'Hairstylist / Makeup Artist', 
                'Lighting / Electrical' => 'Lighting / Electrical', 'Other' => 'Other', 'Personal Assistant' => 'Personal Assistant', 'Producer' => 'Producer', 
                'Production Staff' => 'Production Staff', 'Props' => 'Props', 'Set Design' => 'Set Design', 'Sound' => 'Sound',
                'Stuntman' => 'Stuntman', 'Talent Agent / Literary Agent' => 'Talent Agent / Literary Agent', 'Talent Manager' => 'Talent Manager', 
                'Visual Effects' => 'Visual Effects', 'Writer' => 'Writer'}
    @genres = { 'Action' => 'Action', 'Adventure' => 'Adventure', 'Animation' => 'Animation', 'Biography' => 'Biography',
                'Comedy' => 'Comedy', 'Crime' => 'Crime', 'Documentary' => 'Documentary', 'Drama' => 'Drama', 'Family' => 'Family',
                'Fantasy' => 'Fantasy', 'Film-Noir' => 'Film-Noir', 'History' => 'History', 'Horror' => 'Horror', 'Musical' => 'Musical',
                'Mystery' => 'Mystery', 'Romance' => 'Romance', 'Scifi' => 'Scifi', 'Sports' => 'Sports', 'Thriller' => 'Thriller',
                'War' => 'War', 'Western' => 'Western' }
    @is_type = {'Feature Length' => 'Feature Length', 'Music Video' => 'Music Video', 'Reality' => 'Reality', 'Short' => 'Short',
                'TV Series' => 'TV Series', 'Webisode' => 'Webisode'}
    @status = { 'Draft' => 'Draft', 'Pre-Production' => 'Pre-Production', 'Greenlight' => 'Greenlight', 'Post-Production' => 'Post-Production', 'Completed' => 'Completed'}
    @compensation = {'Paid' => 'Paid', 'Low-Paid' => 'Low-Paid', 'Copy / Credit' => 'Copy / Credit'}
  end
end