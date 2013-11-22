app.views.comment = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#comment_template').html())

  events: 
    'click .like-comment': 'like_comment'
    'click .destroy_comment': 'destroy_comment'
    'click .update': 'update_content'
    'click .edit_comment': 'show_edit_div'
    'click .hide_edit': 'hide_edit_div'
    'keypress textarea.edit_comment_area': 'check_keypress'

  check_keypress: (event)->
    # check if enter is pressed.
    # if enter is pressed when no test is entered, return 0
    val = $(event.target).val()
    if val == '' && event.which == app.constants.enter_key_code
      return false

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

    new_content = $.trim(this.$el.find(".comment-edit-textarea textarea").val())

    if new_content != ''
      $.ajax
        url: '/comments/'+_this.model.id
        type: 'POST'
        data: 
          comment:
            content: new_content
        success: (resp)->
          _this.model.set('content', new_content)
          _this.render()
          _this.$el.find('.comment-edit-textarea').hide()
          _this.$el.find('.comment-content').show()


  destroy_comment: ()->
    _this = this
    this.model.destroy
      success: (model, resp) ->
        _this.remove()

  like_comment: (event) ->
    _this = this
    if app.fn.check_current_user()
      if _this.model.get('user_following')
        _this.unlike_comment(event)
      else
        $.ajax
          url: '/likes.json'
          type: 'POST'
          data:
            like:
              loveable_id: _this.model.get('id')
              loveable_type: 'Comment'
          success: (resp) ->
            if resp != 'false'
              _this.model.set('user_following', true)
              count_div = _this.$el.find('.like-comment .likes-count')
              likes_count = count_div.html()
              _this.$el.find('.heart-blue').addClass('active')
              count_div.html(parseInt(likes_count) + 1)
            else
              alert 'Something went wrong, Please try laters'

  unlike_comment: (event)->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user()
      $.ajax
        url: '/likes/unlike'
        type: 'POST'
        data:
          like:
            loveable_id: _this.model.get('id')
            loveable_type: 'Comment'
        success: (resp) ->
          if resp != 'false'
            _this.model.set('user_following', false)
            count_div = _this.$el.find('.like-comment .likes-count')
            likes_count = count_div.html()
            _this.$el.find('.heart-blue').removeClass('active')
            count_div.html(parseInt(likes_count) - 1)
          else
            alert 'Something went wrong, Please try later'