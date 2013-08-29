app.views.user_events = Backbone.View.extend
  initialize: (options)->
    this.type = options.type
    this.template = _.template($('#user_events_template').html())

  render: ()->
    this.$el.html(this.template)
    this.collection.all_events().forEach(this.renderEachAll, this)
    this.collection.current_events().forEach(this.renderEachCurrent, this)
    this.collection.past_events().forEach(this.renderEachPast, this)
    return this

  renderElem: (user_event)->
    user_event_view = new app.views.user_event({ model: user_event })
    user_event_view.render()

  renderEachAll: (user_event) ->
    this.$el.find('#user-event-tab-all .message_for_empty').hide()
    this.$el.find('#user-event-tab-all').append( this.renderElem(user_event).el )

  renderEachCurrent: (user_event) ->
    this.$el.find('#user-event-tab-current .message_for_empty').hide()
    this.$el.find('#user-event-tab-current').append( this.renderElem(user_event).el )

  renderEachPast: (user_event) ->
    this.$el.find('#user-event-tab-past .message_for_empty').hide()
    this.$el.find('#user-event-tab-past').append( this.renderElem(user_event).el )