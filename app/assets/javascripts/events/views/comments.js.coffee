app.views.comments = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#comments_template').html())
    this.collection.on('add', this.renderEach, this)
  events: 
    'keypress #add_comment': 'check_keypress'

  render: ()->
    this.$el.html( this.template() )
    this.collection.forEach(this.renderEach, this)
    this

  renderEach: (comment)->
    comment_view = new app.views.comment({ model: comment })
    this.$el.find('#comments_display').prepend(comment_view.render().el)

  check_keypress: (event)->
    # check if enter is pressed.
    if event.which == app.constants.enter_key_code
      this.add_comment(event)

  add_comment: (event)->
    _this = this
    element = $(event.target)

    $('#comment_please_wait').show()
    element.attr('disabled', 'disabled')

    if element.val() != ''
      $.ajax
        url: '/events/add_comment'
        type: 'POST'
        data:
          event_id: app.event_data.id
          content: element.val()
        success: (resp)->
          if resp != 'false'
            comment = new app.models.comment(resp)
            _this.collection.add(comment)
            $('#comment_please_wait').hide()
            element.attr('disabled', false)
            element.val('')
          else
            alert 'There is some error posting your comment. Please try again later'


