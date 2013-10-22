app.views.similar_event = Backbone.View.extend
  className: 'similar_event clearfix'
  initialize: ()->
    this.template = _.template($('#similar_event_template').html())
    app.events.bind('change_event_model'+this.model.id, this.set_and_render, this)

  events: 
    'click .attend-event': 'attend'
    'click .unattend-event': 'unattend'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  set_and_render: (event_data) ->
    this.model.set(event_data.attributes)
    this.render()

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
