app.views.comment = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#comment_template').html())

  events: 
    'click .like-comment': 'like_comment'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

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