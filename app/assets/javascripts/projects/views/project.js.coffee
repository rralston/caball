app.views.project = Backbone.View.extend
  className: 'project'
  initialize: ()->
    this.template = _.template($('#project_template').html())

  events: 
    'click .btn-follow': 'follow_project'


  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  follow_project: (event)->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user() and app.fn.check_not_same_user(_this.model.get('user').id, "You can't like your own project.")
      btn.html('Please wait..')
      if _this.model.get('user_following')
        _this.un_follow_project(event)
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
              count = _this.$el.find('.fans-count').html()
              _this.$el.find('.fans-count').html(parseInt(count) + 1)
              btn.html('Un Like')
            else
              alert 'Something went wrong, Please try laters'

  un_follow_project: (event) ->
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
            count = _this.$el.find('.fans-count').html()
            _this.model.set('user_following', false)
            _this.$el.find('.fans-count').html(parseInt(count) - 1)
            btn.html('Like')
          else
            alert 'Something went wrong, Please try laters'