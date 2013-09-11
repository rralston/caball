class ProjectsController < ApplicationController

  load_and_authorize_resource :except => [:show]

  after_filter :clear_temp_photo_objects, :only => [:update, :create]
  
  def index
    search(Project, "projects")

    # if page is present, it indicates that request is for load more
    if params[:page].present?
      page = params[:page]
      type = params[:load_type]

      if type == 'recent'
        @projects = Project.recent_projects(page, PROJECTS_PER_PAGE_IN_INDEX)
      
      elsif type == 'search'
        
        params[:roles].delete('') if params[:roles] # delete empty string that is appended in few cases
        params[:genres].delete('') if params[:genres]
        params[:types].delete('') if params[:types]

        roles    = params[:roles]
        types    = params[:types]
        genres   = params[:genres]
        search   = params[:search] || params[:keyword]
        location = params[:location]
        order_by = params[:order_by]
        # default distance 100
        distance = params[:distance].present? ? params[:distance] : 100

        to_be_filtered_projects = nil

        if params[:people].present?
          # projects_by_friends / projects_by_followers are the possible cases.
          to_be_filtered_projects = Project.send("projects_by_#{params[:people]}", current_user)
        end

        @projects = Project.search_all(to_be_filtered_projects, search, roles, genres, types, location, distance, order_by, page, 6)

        # @projects = Project.search_all(nil, nil, nil, nil, nil, nil, nil, 1, PROJECTS_PER_PAGE_IN_INDEX)
      end

    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => Project.custom_json(@projects, current_user) }
    end
  end
  
  def show
    search(Project, "projects")

    if params[:id].to_i > 0 #to_i will return 0 if the id is a string
      @project = Project.find(params[:id])
    else
      @project = Project.find_by_url_name(params[:id])
    end

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
    @project.user = current_user
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

  def step_1

    if params[:project_id].present?
      # editing
      @project = Project.find(params[:project_id])
      if @project.update_attributes(params[:project])
        render 'projects/step_2_form', :layout => false
      else
        debugger
        render :json => false
      end
    else
      # new project
      if @project = Project.create(params[:project])
        @project.user = current_user
        @project.save
        render 'projects/step_2_form', :layout => false
      else

        render :json => false
      end
    end
  end

  def step_2
    @project = Project.find(params[:project_id])
    if @project.update_attributes(params[:project])
      render 'projects/step_3_form', :layout => false
    else
      render :json => false
    end
  end


  def add_filled_role
    project = Project.find(params[:project_id])

    if params[:role][:id].present?

      role = Role.find(params[:role][:id])

      # making the subroles nil and cast just in case if it as subroles before and when edited the new data doesn't have a subrole.
      role.reset_optional_fields
      
      params[:role].delete(:id)
      
      role.update_attributes(params[:role])
    else
      role = project.roles.create(params[:role])
      # role.applications.create(:user_id => params[:role_user_id], :approved => true)
      # role.update_attributes(:filled => true)
    end
    render :json => role.to_json(:include => [{:applications => { :include => :user}}])
  end



  def files_upload
    
    if params['project']['photos_attributes'].present?
      attributes = params['project']['photos_attributes']

      # get the index of the parameters with image attribute present
      indexes_with_image = attributes.map do |index, attribute|
        if attribute.include?('image')
          index
        end
      end

      indexes_with_image.delete(nil)

      # only one image is submitted once anyway.
      index = indexes_with_image.first

      if index.present?
        # if id is present, that is a photo object that is already existing and being updated.
        if params['project']['photos_attributes'][index]['id'].present?
          photo_object = Photo.find(params['project']['photos_attributes'][index]['id'].to_i)
        else
          # id won't be present for those photos that are dynamically added by Numerous.js
          photo_object = Photo.new
        end

        photo_object.update_attributes(:image => params['project']['photos_attributes'][index]['image'])

        if  Rails.env == 'development'
          url = "http://" + request.env["HTTP_HOST"] + photo_object.image.url
        else
          url = photo_object.image.url
        end
        
        file_url = {
          :url => url,
          :id => photo_object.reload.id,
          :original_width => photo_object.reload.original_width,
          :original_height => photo_object.reload.original_height
        }
        
      end

    end
    render :json => file_url.to_json()
  end
    
  def project_fields
    @talents      = Project.role_types
    @genres       = Project.genres
    @is_type      = Project.types
    @unions       = Project.unions
    @status       = Project.status_stages
    @compensation = Project.compensation_stages
  end

end