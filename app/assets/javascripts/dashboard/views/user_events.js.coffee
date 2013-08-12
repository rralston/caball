app.views.user_events = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#user_events_template').html())
  
  render: ()->
    this.$el.html(this.template)
    
    # this.collection.forEach(this.renderEach, this)
    this.collection.popular_events().forEach(this.renderEachPopular, this)
    this.collection.upcoming_events().forEach(this.renderEachUpcoming, this)
    this.collection.past_events().forEach(this.renderEachPast, this)
    return this

  renderElem: (user_event)->
    user_event_view = new app.views.user_event({ model: user_event })
    user_event_view.render()

  renderEachPopular: (user_event) ->
    this.$el.find('#event-tab-popular').append( this.renderElem(user_event).el )

  renderEachUpcoming: (user_event) ->
    this.$el.find('#event-tab-upcoming').append( this.renderElem(user_event).el )

  renderEachPast: (user_event) ->
    this.$el.find('#event-tab-past').append( this.renderElem(user_event).el )
