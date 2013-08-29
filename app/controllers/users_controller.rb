class UsersController < ApplicationController

  load_and_authorize_resource :except => [:show, :next_recommended_projects, :next_recommended_people, :next_recommended_events, :set_notification_check_time]
  
  before_filter :search, only: [:index, :show, :new, :edit, :update, :dashboard]
  before_filter :authenticate_user!, only: [:dashboard]

  def index
    @talents = User.types

    # if page is present, it indicates that request is for load more
    if params[:page].present?
      page = params[:page]
      type = params[:load_type]
      
      if type == 'recent'
        @users = User.recently_updated(page, USERS_PER_PAGE_IN_INDEX)
      
      elsif type == 'search'

        if params[:roles]
          params[:roles].delete('') # delete empty string that is appended in few cases
        end

        roles    = params[:roles]
        search   = params[:search] || params[:keyword]
        location = params[:location]
        cast_hash = {
          :height => params[:height],
          :ethnicity => params[:ethnicity],
          :bodytype => params[:bodytype],
          :hair_color => params[:hair_color],
          :language => params[:language]
        }
        distance = 100

        Characteristics.clear_empty cast_hash

        if params[:distance].present?
          distance = params[:distance]
        end

        to_be_filtered_users = nil

        if params[:people].present?
          # params[:people] contains followers or friends which are methods on user.
          to_be_filtered_users = current_user.send(params[:people])
        end

        @users = User.filter_all(to_be_filtered_users, search, location, distance, roles, cast_hash, page, USERS_PER_PAGE_IN_INDEX)
      end
    else
      @users = User.recently_updated

    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        if current_user.present?
          @users = @users - [current_user]
        end
        render :json => @users.to_a.to_json(:include => :followers, :check_user => current_user) 
      }
    end
  end
  
  def show

    if params[:id].to_i > 0 #to_i will return 0 if the id is a string
      @user = User.find(params[:id])
    else
      @user = User.find_by_url_name(params[:id])
    end

    @blog = Blog.new
    @real_videos = @user.videos.real
    @followers_following = (@user.friends + @user.followers).uniq
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
  
  ## ALERT : is this being used?
  def new
    @user.build_characteristics
    @user.build_profile
  end

  def edit
    @talents = User.types
    @experience = User.experience
    @user.talents.present? || @user.talents.build
  end
   
  def create
    respond_to do |format|
      if @user.save
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
  end

  def step_1
    if current_user.update_attributes(params[:user])
      render 'users/step_2_form', :layout => false
    else
      render :json => false
    end
  end

  def step_2
    if current_user.update_attributes(params[:user])
      render 'users/step_3_form', :layout => false
    else
      render :json => false
    end
  end

  def step_3
    if current_user.update_attributes(params[:user])
      redirect_to edit_user_path(current_user), :success => true, :notice => 'User info saved'
    else
      redirect_to edit_user_path(current_user), :success => false, :notice => 'User info not saved'
    end
  end

  def files_upload    
    # TODO: try to send only required parameters from client side if possible.

    if params['user']['profile_attributes'].present? and params['user']['profile_attributes']['image'].present?
      current_user.profile = Profile.new if current_user.profile.nil?

      current_user.profile.update_attributes(params['user']['profile_attributes'])
      file_url = current_user.profile.image.url(:medium)
    end

    # check if the talents scrip_document is sent.
    if params['user']['talents_attributes'].present? and (params['user']['talents_attributes']["0"].present?)
      
      # if first talent has the script document.
      if params['user']['talents_attributes']["0"]['script_document_attributes'].present?
        # build docuemnt if its not present
        current_user.talents.last.script_document = UploadedDocument.new if current_user.talents.last.script_document.nil?

        current_user.talents.first.script_document.update_attributes(:document => params['user']['talents_attributes']["0"]["script_document_attributes"]["document"])
        file_url = current_user.talents.first.reload.script_document.document.url
      
      # if second talent has the script document.
      elsif params['user']['talents_attributes']["1"].present? and params['user']['talents_attributes']["1"]['script_document_attributes'].present?
        # build docuemnt if its not present
        current_user.talents.last.script_document = UploadedDocument.new if current_user.talents.last.script_document.nil?

        current_user.talents.last.script_document.update_attributes(:document => params['user']['talents_attributes']["1"]["script_document_attributes"]["document"])
        file_url = current_user.talents.last.reload.script_document.document.url
      end
    end

    # check if resume attribtues are present    
    if params['user']['resume_attributes'].present? and params['user']['resume_attributes']["document"].present?
      # build resume if its not present
      current_user.resume = UploadedDocument.new if current_user.resume.nil?

      current_user.resume.update_attributes(params['user']['resume_attributes'])
      file_url = current_user.resume.document.url
    end

  
    # cover photo uploader.
    if params['user']['cover_photo_attributes'].present? and params['user']['cover_photo_attributes']['image'].present?
      # build cover photo if cover photo doesn't exists.
      if current_user.cover_photo.nil?
        cover_photo = Photo.new
        cover_photo.update_attributes(params['user']['cover_photo_attributes'])
        current_user.cover_photo = cover_photo
        current_user.save
      else
        current_user.cover_photo.update_attributes(params['user']['cover_photo_attributes'])
      end

      file_url = current_user.cover_photo.image.url(:medium)
    end

    if params['user']['photos_attributes'].present?
      attributes = params['user']['photos_attributes']

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
        if params['user']['photos_attributes'][index]['id'].present?
          photo_object = current_user.photos.find(params['user']['photos_attributes'][index]['id'].to_i)
        else
          # id won't be present for those photos that are dynamically added by Numerous.js
          photo_object = current_user.photos.new
        end

        photo_object.update_attributes(:image => params['user']['photos_attributes'][index]['image'])

        file_url = {
          :url => photo_object.image.url(:medium),
          :id => photo_object.reload.id
        }
      end
    end

    render :json => file_url.to_json()

  end

  # custom update for handling ajax updates
  def custom_update
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    render :text => true
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, :notice => 'Sorry to see you leave :-(' }
    end
  end

  def profile
    redirect_to user_path(current_user)
  end

  def dashboard
    @user = current_user
    render :template => 'dashboard/index'
  end

  def dashboard_projects
    resp = {}
    resp['user_projects'] = current_user.projects
    resp['applied_projects'] = current_user.applied_projects
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json {
        render :json => resp.to_json(:include => 
                                      [
                                        :open_roles,
                                        :filled_roles,
                                        :roles,
                                        :photos,
                                        :fans,
                                        :user
                                      ],
                                      :methods => [
                                        :pending_applications,
                                        :participant_mails,
                                        :roles_json,
                                        :roles_for_dashboard,
                                        :roles_percent,
                                        :non_selected_applicants_mails,
                                        :selected_applicants_mails
                                      ])
      }
    end
  end


  def dashboard_events
    resp = {}
    resp['user_events'] = current_user.events
    resp['attending_events'] = current_user.attending_events
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json {
        render :json => resp.to_json(:include => [
                                                    :attendees,
                                                    { 
                                                      :start => {
                                                        :methods => [
                                                          :day,
                                                          :month_year
                                                        ]
                                                      }
                                                    },
                                                    {
                                                      :end => {
                                                        :methods => [
                                                          :day,
                                                          :month_year
                                                        ]
                                                      } 
                                                    },
                                                    :comments,
                                                    :likes,
                                                    :main_photo,
                                                    :user
                                                  ],
                                                  :methods => [
                                                    :attendees_emails
                                                  ],
                                                  :check_user => current_user
                                                )
      }
    end
  end

  def dashboard_conversations
    resp = {}
    resp['inbox_conversations'] = current_user.mailbox.inbox
    resp['sent_conversations'] = current_user.mailbox.sentbox
    resp['trash_conversations'] = current_user.mailbox.trash

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json {
        render :json => resp.to_json(:check_user => current_user)
      }
    end
  end

  def next_recommended_projects
    projects = current_user.recommended_projects.paginate(:page => params[:page_number], :per_page => RECOMMENDED_PROJECTS_PER_PAGE)
    respond_to do |format|
      format.json { render :json => Project.custom_json(projects, current_user) }
    end
  end

  def next_recommended_people
    people = current_user.recommended_people.paginate(:page => params[:page_number], :per_page => RECOMMENDED_PEOPLE_PER_PAGE)
    respond_to do |format|
      format.json { render :json => people.to_json() }
    end
  end
  

  def next_recommended_events
    events = current_user.recommended_events.paginate(:page => params[:page_number], :per_page => RECOMMENDED_EVENTS_PER_PAGE)
    respond_to do |format|
      format.json { render :json => Event.custom_json(events, current_user) }
    end
  end

  def set_notification_check_time
    current_user.update_attributes(:notification_check_time => Time.now())
    render :text => 'true'
  end

  def agent_names
    agents = User.agents.where('lower(users.name) LIKE lower(?)', "%#{params[:q]}%")
    render :json => agents.to_json(:only => [:name, :id])
  end

  def change_password
    if !current_user.valid_password? params[:currentPassword]
      @errors = "Invalid password."
    else
      if !current_user.reset_password!(params[:password], params[:confirmPassword])
        @errors = "Passwords do not Match."
      end
    end
    respond_to do |format|
      format.js #change_password.js.erb
    end
  end

  def change_email
    current_user.update_attributes email: params[:newEmail]
    respond_to do |format|
      format.js #change_email.js.erb
    end
  end
end