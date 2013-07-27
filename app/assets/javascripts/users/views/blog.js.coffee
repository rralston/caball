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
    if app.current_user != null
      if app.fn.check_if_current_user_included(this.model.get('liker_ids'))
        alert 'you have already liked this post'
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
              _this.model.set(resp)
              _this.render()
            else
              alert 'Something went wrong, Please try laters'