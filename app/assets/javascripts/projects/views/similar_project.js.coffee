app.views.similar_project = Backbone.View.extend
  className: 'project pull-left'
  initialize: ()->
    this.template = _.template($('#similar_project_template').html())

  events:
    'click .likes': 'like_project'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  like_project: (event)->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user()
      if _this.model.get('user_following')
        _this.unlike_project(event)
      else
        $.ajax
          url: '/likes.json'
          type: 'POST'
          data:
            like:
              loveable_id: _this.model.get('id')
              loveable_type: 'Project'
          success: (resp) ->
            if resp != 'false'
              _this.model.set('user_following', true)
              count = _this.$el.find('.likes .count').html()
              _this.$el.find('.likes .count').html(parseInt(count) + 1)
            else
              alert 'Something went wrong, Please try laters'

  unlike_project: (event) ->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user()
      $.ajax
        url: '/likes/unlike'
        type: 'POST'
        data:
          like:
            loveable_id: _this.model.get('id')
            loveable_type: 'Project'
        success: (resp) ->
          if resp != 'false'
            _this.model.set('user_following', false)
            count = _this.$el.find('.likes .count').html()
            _this.$el.find('.likes .count').html(parseInt(count) - 1)
          else
            alert 'Something went wrong, Please try laters'