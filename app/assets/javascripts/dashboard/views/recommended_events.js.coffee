app.views.recommended_events = Backbone.View.extend
  initialize: ()->
    app.events.on('next_recommended_events', this.next_events)
    this.template = _.template($('#recommended_events_template').html())
    this.collection.on('add', this.render, this)

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

  next_events: (event)->
    page_number = parseInt($(event.target).attr('data-next'))
    console.log 'here'
    $.ajax
      url: '/users/recommended_events'
      data: 
        page_number: page_number
      success: (resp)->
        # if type is object it will contain new events to load.
        if resp.length > 0
          new_recommended_event_models = _.map(resp, (event_json)->
            new app.models.recommended_event(event_json)
          )
          app.recommended_events.add(new_recommended_event_models)
          # increment page number on the loadmore button
          $(event.target).attr('data-next', ++page_number)
        else
          alert('No more recommendations available')
          $(event.target).hide()