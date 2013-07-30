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
    if app.fn.check_current_user()
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
              btn.html('Following')
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
            btn.html('Follow')
          else
            alert 'Something went wrong, Please try laters'