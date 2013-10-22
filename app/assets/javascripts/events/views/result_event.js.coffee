app.views.result_event = Backbone.View.extend
  className: 'result_event clearfix'
  initialize: ()->
    this.template = _.template($('#result_event_template').html())
    app.events.bind('change_event_model'+this.model.id, this.set_and_render, this)

  events: 
    'click .attend-event': 'attend'
    'click .unattend-event': 'unattend'
    'click .up-vote': 'up_vote'
    'click .down-vote': 'down_vote'
    'click .like-event': 'like_event'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  set_and_render: (event_data) ->
    this.model.set(event_data.attributes)
    this.render()

  up_vote: (event)->
    this.vote(event, 'up_vote')

  down_vote: (event)->
    this.vote(event, 'down_vote')

  vote: (event, type) ->
    btn = $(event.target)
    _this = this
    if app.fn.check_current_user() and !(btn.hasClass('active'))
      btn.addClass('active')
      $.ajax
        url: '/events/'+type
        type: "POST"
        data:
          id: _this.model.id
        success: (resp)->
          if resp != 'false'
            _this.model.set(resp)
            app.events.trigger('change_event_model'+_this.model.id, _this.model)
          else
            alert 'Something went wrong. Please try later'
            btn.removeClass('active')


  attend: (event)->
    btn = $(event.target)
    _this = this
    if app.fn.check_current_user()
      btn.html('Please Wait..')
      $.ajax
        url: '/events/attend'
        type: 'POST'
        data:
          id: _this.model.id
        success: (resp) ->
          if resp != 'false'
            btn.html('Attending').removeClass('attend-event').addClass('unattend-event')
            _this.model.set('user_attending', true)
            app.events.trigger('change_event_model'+_this.model.id, _this.model)
          else
            alert 'Something went wrong. Please try later'
            btn.html('Attend')

  unattend: (event)->
    btn = $(event.target)
    _this = this
    if app.fn.check_current_user()
      btn.html('Please Wait..')
      $.ajax
        url: '/events/unattend'
        type: 'POST'
        data:
          id: _this.model.id
        success: (resp) ->
          if resp != 'false'
            btn.html('Attend').addClass('attend-event').removeClass('unattend-event')
            _this.model.set('user_attending', false)
            app.events.trigger('change_event_model'+_this.model.id, _this.model)
          else
            alert 'Something went wrong. Please try later'
            btn.html('Attending')

  like_event: (event) ->
    _this = this
    if app.fn.check_current_user()
      if _this.model.get('user_liked')
        _this.unlike_event(event)
      else
        $.ajax
          url: '/likes.json'
          type: 'POST'
          data:
            like:
              loveable_id: _this.model.get('id')
              loveable_type: 'Event'
          success: (resp) ->
            if resp != 'false'
              _this.model.set('user_liked', true)
              likes_count = _this.$el.find('.likes .count').html()
              _this.$el.find('.heart-blue').addClass('active')
              _this.$el.find('.likes .count').html(parseInt(likes_count) + 1)
              # _this.render()
            else
              alert 'Something went wrong, Please try laters'

  unlike_event: (event)->
    _this = this
    btn = $(event.target)
    if app.fn.check_current_user()
      $.ajax
        url: '/likes/unlike'
        type: 'POST'
        data:
          like:
            loveable_id: _this.model.get('id')
            loveable_type: 'Event'
        success: (resp) ->
          if resp != 'false'
            _this.model.set('user_liked', false)
            likes_count = _this.$el.find('.likes .count').html()
            _this.$el.find('.heart-blue').removeClass('active')
            _this.$el.find('.likes .count').html(parseInt(likes_count) - 1)
          else
            alert 'Something went wrong, Please try later'
