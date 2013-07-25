class EventsController < ApplicationController

  load_and_authorize_resource

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
    @event = Event.find(params[:id])
  end

  def new
    search
    @event = Event.new()
  end
  
  def create
    search
    @event.user_id = current_user.id
    if @event.save
      redirect_to @event
    else
      render :new, notice: 'Please correct the errors'
    end
  end

  def edit
    search
    @user = current_user
    @event = Event.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to @event, notice: "Event was updated."
    else
      render :edit
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
    body = "#{current_user.name} has invited you to the event - #{event.title}"
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

end