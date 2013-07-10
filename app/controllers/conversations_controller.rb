class ConversationsController < ApplicationController

  load_and_authorize_resource
  
  before_filter :search
  helper_method :mailbox, :conversation
  
  def new
    @recipient = params[:recipient]
    if params[:subject]
      @subject  = params[:subject]
    end
    if params[:modal]
      @modal = true
      respond_to do |format|
        format.html { render :layout => false }# show.html.erb
      end
    end
  end
  
  def create
    # Standard Part
    recipient_emails = conversation_params(:recipients).split(',')
    recipients = User.where(email: recipient_emails).all

    conversation = current_user.
      send_message(recipients, *conversation_params(:body, :subject)).conversation

    redirect_to conversations_url, :notice => 'Your Message was successfully sent.'
  end

  # Destroy Message form the System
  def destroy
    Notification.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_admin_messages_url, :notice => 'Message has been deleted' }
    end
  end
  
  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
    redirect_to :conversation
  end
   
  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :conversations
  end
  
  #Bring in Details from Documentation Here Also Add to Routes
  def unread
    conversation.mark_as_unread(current_user)
    redirect_to :conversations
  end

  def read
    conversation.mark_as_read(current_user)
    redirect_to :conversations
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