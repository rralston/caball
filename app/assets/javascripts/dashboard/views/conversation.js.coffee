app.views.conversation = Backbone.View.extend
  className: 'conversation span4'
  initialize: ()->
    this.template = _.template($('#conversation_template').html())

  events:
    'click .delete_conversation': 'delete_conversation'
    'click .undelete_conversation': 'undelete_conversation'
    'click' : 'show_messages'


  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    if this.model.get('is_read') != true
      this.$el.addClass('un_read')
    return this

  show_messages: (event)->
    this.fetch_messages()
    this.$el.closest('.tab-pane').find('.conversation.active').removeClass('active')
    this.$el.addClass('active')
    # remove the unread class if it has.
    if this.$el.hasClass('un_read')
      this.$el.removeClass('un_read')
      this.$el.find('.notno').hide()
      # update the total unread count of mesages
      tot_unread_count = $('.convos_unread_count').html()
      $('.convos_unread_count').html( parseInt(tot_unread_count) - parseInt(this.model.get('unread_count')) )

  fetch_messages: ()->
    _this = this
    container = this.$el.first().closest('.tab-pane').find('.messages_container')
    container.html('Please wait while we load your messages...')
    $.ajax
      url: '/conversations/get_messages.json'
      type: "GET"
      data:
        id: _this.model.get('id')
      success: (resp)->
        if resp != 'false'
          if resp.length > 0
            messages = new app.collections.messages(resp)
            messages_view = new app.views.messages({ collection: messages, conversation: _this.model, mailbox_type: _this.model.collection.mailbox_type })
            container.html(messages_view.render().el)
          else
            alert('No messages found.')
            container.html('No messages found.')  
        else 
          alert('Something went wrong, Please try again later')

  delete_conversation: (event)->
    event.stopPropagation()
    _this = this
    $.ajax
      url: '/conversations/' + _this.model.get('id') + '/trash.json'
      type: "POST"
      success: (resp)->
        if resp == true
          # conversation = new app.models.conversation( _this.model )
          # app.trash_conversations.add(conversation)
          _this.model.collection.remove(_this.model)
        else
          alert('Something went wrong, Please try again.')
          _this.$el.show()

  undelete_conversation: (event)->
    event.stopPropagation()
    _this = this
    $.ajax
      url: '/conversations/' + _this.model.get('id') + '/untrash.json'
      type: "POST"
      success: (resp)->
        if resp == true
          # conversation = new app.models.conversation( _this.model )
          # if _this.model.get('originator').id == app.current_user.id
          #   # the current user is the originator of the message, so this should be added to SENT messages
          #   app.sent_conversations.add(conversation)
          # else
          #   # if the originator is different add this to INBOX
          #   app.inbox_conversations.add(conversation)
            
          _this.model.collection.remove(_this.model)

        else
          alert('Something went wrong, Please try again.')
          _this.$el.show()