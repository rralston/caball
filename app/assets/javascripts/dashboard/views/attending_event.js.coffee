app.views.attending_event = Backbone.View.extend
  className: 'event'
  initialize: ()->
    this.template = _.template($('#attending_event_template').html())
    this.model.on('remove_this', this.remove_item, this)

  events: 
    'click .btn-unattend': 'unattend'
    'click .like-event': 'like_event'


  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this

  unattend: ()->
    _this = this
    $.ajax
      url: '/events/unattend'
      type: 'POST'
      data:
        id: _this.model.get('id')
      success: (resp)->
        if resp != false
          _this.model.trigger('remove_this')
        else
          alert('Something went wrong, Please try again later')

  remove_item: ()->
    this.remove()

  like_event: (event) ->
    _this = this
    if app.fn.check_current_user() and app.fn.check_not_same_user(_this.model.get('user').id, "You can't like your own events.")
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