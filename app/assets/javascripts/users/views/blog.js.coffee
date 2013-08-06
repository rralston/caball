app.views.blog = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#blog_template').html())

  events: 
    'click .like-blog': 'like_blog'

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
              count_div = _this.$el.find('.like-comment .likes-count')
              likes_count = count_div.html()
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
            count_div = _this.$el.find('.like-comment .likes-count')
            likes_count = count_div.html()
            count_div.html(parseInt(likes_count) - 1)
          else
            alert 'Something went wrong, Please try later'