class ConversationsController < ApplicationController

  load_and_authorize_resource
  
  before_filter :search, :except => [:send_message_generic]
  helper_method :mailbox, :conversation
  
  def new

    @friends = current_user.friends.pluck('email')
    @recipient = params[:recipient]
    @subject  = params[:subject] if params[:subject]

    if params[:modal]
      @modal = true
      respond_to do |format|
        format.html { render :layout => false }# show.html.erb
      end
    end
  end
  
  def create
    # Standard Part
    recipient_emails = params[:recipients].split(',')
    # recipient_emails = conversation_params(:recipients).split(',')
    recipients = User.where(email: recipient_emails).all
    
    current_user.send_message(recipients, params[:message], params[:conversation][:subject])

    redirect_to conversations_url, :notice => 'Your Message was successfully sent.'
  end

  def send_message_generic
    recipient_emails = params[:recipients].split(',')
    recipients = User.where(email: recipient_emails).all
    subject = params[:subject]
    message = params[:message]
    current_user.send_message(recipients, message, subject)
    render :text => true
  end

  # Destroy Message form the System
  def destroy
    Notification.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_admin_messages_url, :notice => 'Message has been deleted' }
    end
  end
  
  def reply
    receipt = current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
    respond_to do |format|
      format.html { redirect_to :conversation }
      format.json { render :json => receipt.message.to_json(:include => [:sender]) }
    end
  end
   
  def trash
    conversation.move_to_trash(current_user)
    respond_to do |format|
      format.html { redirect_to :conversation }
      format.json { render :text => true }
    end
  end

  def untrash
    conversation.untrash(current_user)
    respond_to do |format|
      format.html { redirect_to :conversation }
      format.json { render :text => true }
    end
  end

  def empty_trash
    current_user.mailbox.trash.destroy_all
    render :text => true
  end
  
  #Bring in Details from Documentation Here Also Add to Routes
  def unread
    conversation.mark_as_unread(current_user)
    redirect_to :conversations
  end

  def read
    conversation.mark_as_read(current_user)
    respond_to do |format|
      format.html { redirect_to :conversation }
      format.json { render :text => true }
    end
  end

  def get_messages
    this_conversation = Conversation.find(params[:id])
    messages = this_conversation.messages

    # mark conversation read for this user, since he has requested to see messages
    conversation.mark_as_read(current_user)
    
    respond_to do |format|
      format.json { render :json => messages.to_json(:include => [:sender], :check_user => current_user) }
    end
  end
  
  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end
  # Mark as read once Conversation has been opened.
  def conversation
    mailbox.conversations.find(params[:id]).receipts_for(current_user).mark_as_read
    @conversation ||= mailbox.conversations.find(params[:id])    
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end
end