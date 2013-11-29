app.views.comments = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#comments_template').html())
    this.collection.on('add', this.renderEach, this)
  events: 
    'keypress textarea#comment_content': 'check_keypress'
    'keyup textarea#comment_content': 'check_postbutton'
    'click button.post_update': 'add_comment'

  render: ()->
    this.$el.html( this.template() )
    this.collection.forEach(this.renderEach, this)
    this

  renderEach: (comment)->
    comment_view = new app.views.comment({ model: comment })
    this.$el.find('#comments_display').prepend(comment_view.render().el)

  check_keypress: (event)->
    # check if enter is pressed.
    # if enter is pressed when no test is entered, return 0
    val = $(event.target).val()
    if val == '' && event.which == app.constants.enter_key_code
      return false

  check_postbutton: (event) ->
    # toggle post button based on the value in the input
    if $(event.target).val() || app.post_button_shown
      this.$el.find('.post_comment_btn').show()
    else
      this.$el.find('.post_comment_btn').hide()

  add_comment: (event)->
    _this = this
    element = $(event.target)
    if app.current_user != null
      $('#comment_please_wait').show()
    
      $('#new_comment').submit()
      element.attr('disabled', 'disabled')
      $('#comment_video_attributes_url').attr('disabled', 'disabled')
      $('#comment_photo_attributes_image').attr('disabled', 'disabled')
      $('#comment_url_attributes_url').attr('disabled', 'disabled')
      $('button.post_update').attr('disabled', 'disabled')
      