app.views.attending_events = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#attending_events_template').html())
  
  render: ()->
    this.$el.html(this.template)
    # this.collection.forEach(this.renderEach, this)
    this.collection.popular_events().forEach(this.renderEachPopular, this)
    this.collection.upcoming_events().forEach(this.renderEachUpcoming, this)
    this.collection.past_events().forEach(this.renderEachPast, this)
    return this

  renderElem: (attending_event)->
    attending_event_view = new app.views.attending_event({ model: attending_event })
    attending_event_view.render()

  renderEachPopular: (attending_event) ->
    this.$el.find('#attending-event-tab-popular').append( this.renderElem(attending_event).el )

  renderEachUpcoming: (attending_event) ->
    this.$el.find('#attending-event-tab-upcoming').append( this.renderElem(attending_event).el )

  renderEachPast: (attending_event) ->
    this.$el.find('#attending-event-tab-past').append( this.renderElem(attending_event).el )
