app.views.attending_events = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#attending_events_template').html())
  
  render: ()->
    this.$el.html(this.template)
    this.collection.popular_events().forEach(this.renderEachPopular, this)
    this.collection.upcoming_events().forEach(this.renderEachUpcoming, this)
    this.collection.nearby_events().forEach(this.renderEachNearby, this)
    return this

  renderElem: (attending_event)->
    attending_event_view = new app.views.attending_event({ model: attending_event })
    attending_event_view.render()

  renderEachPopular: (attending_event) ->
    this.$el.find('#attending-event-tab-popular').append( this.renderElem(attending_event).el )

  renderEachUpcoming: (attending_event) ->
    this.$el.find('#attending-event-tab-upcoming').append( this.renderElem(attending_event).el )

  renderEachNearby: (attending_event) ->
    this.$el.find('#attending-event-tab-nearby').append( this.renderElem(attending_event).el )