class ProjectsController < ApplicationController

  load_and_authorize_resource
  
  def index
    search(Project, "projects")
    # @search.build_condition
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
    search(Project, "projects")
    @comment = Comment.new
    @producer = @project.user
    @real_videos = @project.videos.real
    # FIXME
    @sorted_roles = Hash.new
    @project.roles.each do |role|
      if @sorted_roles.has_key?(role.name) then
        @sorted_roles[role.name][:role_list] << role
      else
        @sorted_roles[role.name] = {:role_list => [role], :open_count => 0, :filled_count => 0, :total_count => 0}
      end

      @sorted_roles[role.name][:total_count] += 1

      if role.filled
        @sorted_roles[role.name][:filled_count] += 1
      else
        @sorted_roles[role.name][:open_count] += 1
      end
    end
  end
  
  def edit
    search(Project, "projects")
    project_fields
    3.times do |index|
      @project.photos[index] || @project.photos.build
    end
    @videos = @project.videos
    @videos.present? || @videos.build
  end
  
  def new
    search(Project, "projects")
    project_fields
    @project.roles.build
    3.times do
      @project.photos.build
      @video = @project.videos.build
    end
  end
  
  def create
    @project.user_id = current_user.id
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, :notice => 'Project was successfully created.' }
        format.json { render :json => {
                        :success => true, 
                        :notice => 'Project info was saved' 
                      } }
      else
        format.html { render :action => "new" }
        format.json { render :json => {
                        :success => true, 
                        :notice => 'Project info was saved' 
                      } }
      end
    end
  end

  def update
    params[:project][:genre] = params[:project][:genre].to_json()
    params[:project][:is_type] = params[:project][:is_type].to_json()

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, :notice => @project.title + ' Project was successfully updated.' }
        format.json { render :json => {
                      :success => true, 
                      :notice => 'Project info was saved' 
                    } }
      else
        format.html { render :action => "edit", :notice => 'Project was not created.' }
        format.json { render :json => {
                      :success => true, 
                      :notice => 'Project info was saved' 
                    } }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
     format.html { redirect_to root_url, :notice => @project.title + ' Project was deleted.' }
    end
  end
    
  def project_fields
    @talents = User.types
    @genres = Project.genres
    @is_type = Project.types
    @status = Project.status_stages
    @compensation = Project.compensation_stages
  end
end