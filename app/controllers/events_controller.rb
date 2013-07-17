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
      redirect_to current_user, notice: "Event was updated."
    else
      render :edit
    end
  end

  def attend
    event = Event.find(params[:id])
    event.attends.create(:user => current_user)
    render :text => true
  end

  def unattend
    event = Event.find(params[:id])
    event.attends.where(:user_id => current_user.id).first.destroy
    render :text => true
  end

end