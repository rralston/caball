app.views.blogs = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#blogs_template').html())
    this.collection.on('add', this.renderEach, this)
  events: 
    'keypress textarea#blog_content': 'check_keypress'
    'keyup textarea#blog_content': 'check_postbutton'
    'click button.post_update': 'add_blog'

  render: ()->
    this.$el.html( this.template() )
    this.collection.forEach(this.renderEach, this)
    this

  renderEach: (blog)->
    blog_view = new app.views.blog({ model: blog })
    this.$el.find('#comments_display').prepend(blog_view.render().el)

  render_video_sorted: ()->
    this.$el.find('#comments_display').html('')
    this.collection.video_sorted().forEach(this.renderEach, this)
    this

  render_photo_sorted: ()->
    this.$el.find('#comments_display').html('')
    this.collection.photo_sorted().forEach(this.renderEach, this)
    this

  render_text_sorted: ()->
    this.$el.find('#comments_display').html('')
    this.collection.text_sorted().forEach(this.renderEach, this)
    this

  check_postbutton: (event) ->
    # toggle post button based on the value in the input
    if $(event.target).val() || app.post_button_shown
      this.$el.find('.post_comment_btn').show()
    else
      this.$el.find('.post_comment_btn').hide()

  check_keypress: (event)->
    # check if enter is pressed.
    # if enter is pressed when no test is entered, return 0
    val = $(event.target).val()
    if val == '' && event.which == app.constants.enter_key_code
      return false

  add_blog: (event)->
    _this = this
    element = $(event.target)
    if app.current_user != null
      $('#comment_please_wait').show()
    
      $('#new_blog').submit()
      element.attr('disabled', 'disabled')
      $('#blog_video_attributes_url').attr('disabled', 'disabled')
      $('#blog_photo_attributes_image').attr('disabled', 'disabled')
      $('#blog_url_attributes_url').attr('disabled', 'disabled')
      $('button.post_update').attr('disabled', 'disabled')
      