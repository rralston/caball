class EventsController < ApplicationController

  load_and_authorize_resource

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

end