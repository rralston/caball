app.views.activity = Backbone.View.extend
  className: 'activity'
  initialize: ()->
    this.blog_activity_template = _.template($('#blog_activity_template').html())
    this.project_activity_template = _.template($('#project_activity_template').html())
    this.event_activity_template = _.template($('#event_activity_template').html())
    this.comment_activity_template = _.template($('#comment_activity_template').html())
    this.roleapplication_activity_template = _.template($('#roleapplication_activity_template').html())
    this.endorsement_activity_template = _.template($('#endorsement_activity_template').html())


    this.activity_type = this.model.get('trackable_type').toLowerCase()
    this.$el.addClass( this.activity_type )

  events:
    'click .likes': 'like_entity'

  render: ()->
    trackable_type = this.model.get('trackable_type').toLowerCase()
    # render the template based on the trackable type
    this.$el.html this[trackable_type + '_activity_template'] this.model.toJSON()

    return this

  like_entity: (event)->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user()
      if _this.model.get('trackable').user_liked
        _this.unlike_entity(event)
      else
        $.ajax
          url: '/likes.json'
          type: 'POST'
          data:
            like:
              loveable_id: _this.model.get('trackable_id')
              loveable_type: _this.model.get('trackable_type')
          success: (resp) ->
            if resp != 'false'
              _this.model.get('trackable').user_liked = true
              count = _this.$el.find('.likes-count').html()
              _this.$el.find('.heart-blue').addClass('active')
              _this.$el.find('.likes-count').html(parseInt(count) + 1)
            else
              alert 'Something went wrong, Please try laters'

  unlike_entity: (event) ->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user()
      $.ajax
        url: '/likes/unlike'
        type: 'POST'
        data:
          like:
            loveable_id: _this.model.get('trackable_id')
            loveable_type: _this.model.get('trackable_type')
        success: (resp) ->
          if resp != 'false'
            _this.model.get('trackable').user_liked = false
            count = _this.$el.find('.likes-count').html()
            _this.$el.find('.heart-blue').removeClass('active')
            _this.$el.find('.likes-count').html(parseInt(count) - 1)
          else
            alert 'Something went wrong, Please try laters'
