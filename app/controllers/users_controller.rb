class UsersController < ApplicationController

  load_and_authorize_resource :except => [:next_recommended_projects, :next_recommended_people, :next_recommended_events, :set_notification_check_time]
  before_filter :search, only: [:index, :show, :new, :edit, :update, :dashboard]
  
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
        distance = 100

        if params[:distance].present?
          distance = params[:distance]
        end

        to_be_filtered_users = nil

        if params[:people].present?
          # params[:people] contains followers or friends which are methods on user.
          to_be_filtered_users = current_user.send(params[:people])
        end

        @users = User.filter_all(to_be_filtered_users, search, location, distance, roles, page, USERS_PER_PAGE_IN_INDEX)
      end
    else
      @users = User.recently_updated
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users.to_a.to_json(:include => :followers, :check_user => current_user) }
    end
  end
  
  def show
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
    @videos = @user.videos
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
    
    end
  end

  def step_2
    if current_user.update_attributes(params[:user])
      render 'users/step_2_form', :layout => false
    else
    
    end
  end

  def files_upload    
    # TODO: try to send only required parameters from client side if possible.

    if params['user']['profile_attributes'].present? and params['user']['profile_attributes']['image'].present?
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
                                                ])
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
      format.json { render :json => Project.custom_json(projects) }
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
    agents = User.where('lower(users.name) LIKE lower(?)', "%#{params[:q]}%")
    render :json => agents.to_json(:only => [:name, :id])
  end


end