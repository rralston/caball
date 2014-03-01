class EventsController < ApplicationController

  load_and_authorize_resource :except => [:show]

  after_filter :clear_temp_photo_objects, :only => [:update, :create]
  before_filter :set_page_title
  
  def set_page_title
    @page_title = "Events on filmmo"
  end
  
  def index
    search
    @params_used = params
    if params[:search].present?
      query = params[:search]
      @new_events     = Event.search_new_events(query, 1, EVENTS_PER_PAGE_IN_INDEX)
      @popular_events = Event.search_popular_events(query, 1, EVENTS_PER_PAGE_IN_INDEX)
      @events_by_time = Event.search_events_order_by_date(query, 1, EVENTS_PER_PAGE_IN_INDEX)
    else
      @new_events     = Event.new_events(1, EVENTS_PER_PAGE_IN_INDEX)
      @popular_events = Event.popular_events(1, EVENTS_PER_PAGE_IN_INDEX)
      @events_by_time = Event.events_ordered_by_date(1, EVENTS_PER_PAGE_IN_INDEX)
    end

    respond_to do |format|
      format.html { @recent_events = Event.recent_events(1, EVENTS_PER_PAGE_IN_INDEX) }
      format.json { 
        response = {
          :new_events => @new_events,
          :popular_events => @popular_events,
          :events_by_time => @events_by_time
        }
        render :json => Event.custom_json(response, current_user)
      }
    end
  end

  def load_more
    type = params[:type]
    page = params[:page]
    
    if params[:search].present?
      query = params[:search]
      events = case type
      when 'popular'
        Event.search_popular_events(query, page, EVENTS_PER_PAGE_IN_INDEX)
      when 'new'
        Event.search_new_events(query, page, EVENTS_PER_PAGE_IN_INDEX)
      when 'date'
        Event.search_events_order_by_date(query, page, EVENTS_PER_PAGE_IN_INDEX)
      end
    else
      events = case type
      when 'popular'
        Event.popular_events(page, EVENTS_PER_PAGE_IN_INDEX)
      when 'new'
        Event.new_events(page, EVENTS_PER_PAGE_IN_INDEX)
      when 'date'
        Event.events_ordered_by_date(page, EVENTS_PER_PAGE_IN_INDEX)
      when 'recent'
        @recent_events = Event.recent_events(page, EVENTS_PER_PAGE_IN_INDEX)
      end
    end

    render :json => Event.custom_json(events, current_user)
  end

  def show
    search
    if params[:id].to_i > 0 #to_i will return 0 if the id is a string
      @event = Event.find(params[:id])
    else
      @event = Event.find_by_url_name(params[:id])
    end
    @page_title = @event.title+", "+@event.location
  end

  def new
    search
    @event = Event.new()
    # @event.create_main_photo
  end
  
  def create
    search
    params[:event][:user_id] = current_user.id
    if @event.update_attributes(params[:event])
      redirect_to @event
    else
      render :new, notice: 'Please correct the errors'
    end
  end

  def edit
    search
    @user = current_user
    @event = Event.find(params[:id])
    # session[:current_event] = @event
  end

  def update
    @event = current_user.events.find(params[:id])

    DeleteActivities.new( @event ).del_1_day_ago_updates

    if @event.update_attributes(params[:event])
      redirect_to @event, notice: "Event was updated."
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
     format.html { redirect_to admin_admin_events_url, :notice => @event.title + ' Event was deleted.' }
    end
  end
  
  def attend
    event = Event.find(params[:id])
    attend = event.attends.create(:user => current_user)
    render :json => attend.user.to_json()
  end

  def unattend
    event = Event.find(params[:id])
    attend = event.attends.where(:user_id => current_user.id).first.destroy
    render :json => attend.user.to_json()
  end

  def invite_followers
    event = Event.find(params[:event_id])
    host = request.env["HTTP_ORIGIN"]
    body = "#{current_user.name} has invited you to the event - <a href='#{host}/events/#{event.id}'>#{event.title}</a>"
    current_user.send_message(current_user.followers, body, "Event Invitation - #{event.title}")
    render :text => true
  end

  def send_message_to_organizer
    sender = current_user
    event = Event.find(params[:event_id])
    message = params[:message]
    subject = "Reg. Event - #{event.title}"
    current_user.send_message(event.user, message, subject)
    render :text => true
  end

  def up_vote
    event = Event.find(params[:id])
    event.up_vote(current_user)
    render :json => Event.custom_json(event, current_user)
  end

  def down_vote
    event = Event.find(params[:id])
    event.down_vote(current_user)
    render :json => Event.custom_json(event, current_user)
  end


  def files_upload

    if params['event']['main_photo_attributes'].present? and params['event']['main_photo_attributes']['image'].present?
      # if id is present, that is a photo object that is already existing and being updated.
      if params['event']['main_photo_attributes']['id'].present?
        photo_object = Photo.find(params['event']['main_photo_attributes']['id'].to_i)
      else
        # id won't be present for those photos that are dynamically added by Numerous.js
        photo_object = Photo.new
      end

      photo_object.update_attributes(:image => params['event']['main_photo_attributes']['image'])

      if  Rails.env == 'development'
        url = request.env["HTTP_ORIGIN"] + photo_object.image.url
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
    
    if params['event']['other_photos_attributes'].present?
      attributes = params['event']['other_photos_attributes']

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
        if params['event']['other_photos_attributes'][index]['id'].present?
          photo_object = Photo.find(params['event']['other_photos_attributes'][index]['id'].to_i)
        else
          # id won't be present for those photos that are dynamically added by Numerous.js
          photo_object = Photo.new
        end

        photo_object.update_attributes(:image => params['event']['other_photos_attributes'][index]['image'])

        if  Rails.env == 'development'
          url = request.env["HTTP_ORIGIN"] + photo_object.image.url
        else
          url = photo_object.image.url
        end
        
        file_url = {
          :url => url,
          :id => photo_object.reload.id
        }
        
      end

    end
    render :json => file_url.to_json()
  end

end