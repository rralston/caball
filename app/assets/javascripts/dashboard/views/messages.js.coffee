app.views.messages = Backbone.View.extend
  initialize: (options)->
    this.template = _.template($('#messages_template').html())
    this.collection.on('add', this.renderEach, this)
    this.conversation = options['conversation']
    this.collection.mailbox_type = options['mailbox_type']
  events: 
    'keypress textarea#new_message': 'check_keypress'
  
  render: ()->
    this.$el.html( this.template(this.collection.toJSON()) )
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (message)->
    message_view = new app.views.message({ model: message })
    this.$el.find('.messages_list').append(message_view.render().el)

  check_keypress: (event)->
    # check if enter is pressed.
    if event.which == app.constants.enter_key_code
      this.send_reply(event)

  send_reply: (event) ->
    _this = this
    text_box = $(event.target)
    $('.message_please_wait').show()
    text_box.attr('disabled', 'disabled')
    $.ajax
      url: '/conversations/'+ _this.conversation.get('id') + '/reply.json'
      type: 'POST'
      data:
        message:
          body: text_box.val()
          subject: _this.conversation.get('subject')
      success: (resp) ->
        if resp != 'false'
          new_message = new app.models.message(resp)
          _this.collection.add(new_message)
        else
          alert('Somethng went wrong, Please try again later')
        text_box.attr('disabled', false).val('')
        $('.message_please_wait').hide()