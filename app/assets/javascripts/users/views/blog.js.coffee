app.views.blog = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#blog_template').html())

  events: 
    'click .like-blog': 'like_blog'
    'click .destroy_blog': 'destroy_blog'
    'click .update': 'update_content'
    'click .edit_blog': 'show_edit_div'
    'click .hide_edit': 'hide_edit_div'
    'keypress textarea.edit_comment_area': 'check_keypress'

  check_keypress: (event)->
    # check if enter is pressed.
    if event.which == app.constants.enter_key_code
      this.update_content()

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  show_edit_div: ()->
    this.$el.find('.comment-content').hide()
    this.$el.find('.comment-edit-textarea').show()

  hide_edit_div: ()->
    this.$el.find('.comment-edit-textarea').hide()
    this.$el.find('.comment-content').show()

  update_content: ()->
    _this = this
    this.$el.find(".comment-edit-textarea textarea").attr('disabled', 'disabled')
    new_content = $.trim(this.$el.find(".comment-edit-textarea textarea").val())

    if new_content != ''
      $.ajax
        url: '/blogs/'+_this.model.id
        type: 'POST'
        data: 
          blog:
            content: new_content
        success: (resp)->
          _this.model.set('content', new_content)
          _this.render()
          _this.$el.find('.comment-edit-textarea').hide()
          _this.$el.find('.comment-content').show()
          _this.$el.find(".comment-edit-textarea textarea").attr('disabled', false)

  destroy_blog: ()->
    _this = this
    this.model.destroy
      success: (model, resp) ->
        _this.remove()

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  like_blog: (event) ->
    _this = this
    if app.fn.check_current_user()
      if _this.model.get('user_following')
        _this.unlike_blog(event)
      else
        $.ajax
          url: '/likes.json'
          type: 'POST'
          data:
            like:
              loveable_id: _this.model.get('id')
              loveable_type: 'Blog'
          success: (resp) ->
            if resp != 'false'
              _this.model.set('user_following', true)
              count_div = _this.$el.find('.like-blog .likes-count')
              likes_count = count_div.html()
              _this.$el.find('.heart-blue').addClass('active')
              count_div.html(parseInt(likes_count) + 1)
            else
              alert 'Something went wrong, Please try later'

  unlike_blog: (event)->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user()
      $.ajax
        url: '/likes/unlike'
        type: 'POST'
        data:
          like:
            loveable_id: _this.model.get('id')
            loveable_type: 'Blog'
        success: (resp) ->
          if resp != 'false'
            _this.model.set('user_following', false)
            count_div = _this.$el.find('.like-blog .likes-count')
            likes_count = count_div.html()
            _this.$el.find('.heart-blue').removeClass('active')
            count_div.html(parseInt(likes_count) - 1)
          else
            alert 'Something went wrong, Please try later'