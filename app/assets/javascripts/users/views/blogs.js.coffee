app.views.blogs = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#blogs_template').html())
    this.collection.on('add', this.renderEach, this)
  events: 
    'keypress textarea#blog_content': 'check_keypress'

  render: ()->
    this.$el.html( this.template() )
    this.collection.forEach(this.renderEach, this)
    this

  renderEach: (blog)->
    blog_view = new app.views.blog({ model: blog })
    this.$el.find('#comments_display').prepend(blog_view.render().el)

  check_keypress: (event)->
    # check if enter is pressed.
    if event.which == app.constants.enter_key_code
      this.add_blog(event)

  add_blog: (event)->
    _this = this
    element = $(event.target)
    if app.current_user != null
      $('#comment_please_wait').show()
    
      $('#new_blog').submit()
      element.attr('disabled', 'disabled')