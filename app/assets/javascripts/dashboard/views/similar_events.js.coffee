app.views.recommended_events = Backbone.View.extend
  initialize: (options)->
    this.type = options.type
    this.template = _.template($('#recommended_events_template').html())

  render: ()->
    this.$el.html(this.template)
    this.collection.all_events().forEach(this.renderEachAll, this)
    this.collection.current_events().forEach(this.renderEachCurrent, this)
    this.collection.past_events().forEach(this.renderEachPast, this)
    return this

  renderElem: (recommended_event)->
    recommended_event_view = new app.views.recommended_event({ model: recommended_event })
    recommended_event_view.render()

  renderEachAll: (recommended_event) ->
    this.$el.find('#recommended-event-tab-all').append( this.renderElem(recommended_event).el )

  renderEachCurrent: (recommended_event) ->
    this.$el.find('#recommended-event-tab-current').append( this.renderElem(recommended_event).el )

  renderEachPast: (recommended_event) ->
    this.$el.find('#recommended-event-tab-past').append( this.renderElem(recommended_event).el )