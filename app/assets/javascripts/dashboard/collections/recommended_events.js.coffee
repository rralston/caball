app.collections.recommended_events = Backbone.Collection.extend
  model: app.models.recommended_event

  past_events: ()->
    past_events = _.filter(this.models, (event_object) -> 
      return Date.parse(event_object.get('start').date_time) < Date.parse(Date())
    )
    past_events

  current_events: ()->
    upcoming_events = _.filter(this.models, (event_object) ->
      return Date.parse(event_object.get('start').date_time) > Date.parse(Date())
    )
    
    _.sortBy( upcoming_events, (event_object) ->
      return Date.parse(event_object.get('start').date_time)
    )

  all_events: ()->
    this.models
