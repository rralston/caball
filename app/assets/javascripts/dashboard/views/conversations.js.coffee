app.views.conversations = Backbone.View.extend
  initialize: (options)->
    this.template = _.template($('#conversations_template').html())
    this.collection.mailbox_type = options['mailbox_type']
    this.collection.on('add', this.render, this)
    this.collection.on('remove', this.render, this)

  events: 
    'click .empty_trash': 'empty_trash'
  render: ()->
    this.collection.set_values() # this will set the unread and messages count
    this.$el.html( this.template(this.collection.toJSON()) )
    this.collection.time_sorted().forEach(this.renderEach, this)
    return this

  renderEach: (conversation)->
    # this check is to prevent rendering the conversation of those users who are deleted or not present in the database.
    # this is actually a fail safe when other user in a conversation is no more present in the database
    if conversation.get('originator') != null && conversation.get('other_user_names').length > 0 
      conversation_view = new app.views.conversation({ model: conversation })
      this.$el.find('.conversations_list').prepend(conversation_view.render().el)

  empty_trash: (event) ->
    _this = this
    btn = $(event.target)
    btn.html('Please wait...')
    if this.collection.mailbox_type == 'Trash'
      $.ajax
        url: '/conversations/empty_trash'
        type: 'POST'
        success: (resp)->
          _this.collection.reset([])
          _this.render()
    else     
      alert('Something is wrong, Please try again.')
    btn.html('Empty Trash')