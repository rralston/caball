app.collections.similar_events = Backbone.Collection.extend
  model: app.models.similar_event

  past_events: ()->
    past_events = _.filter(this.models, (event_object) -> 
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/')) < Date.parse(Date())
    )
    past_events

  current_events: ()->
    upcoming_events = _.filter(this.models, (event_object) ->
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/')) > Date.parse(Date())
    )
    
    _.sortBy( upcoming_events, (event_object) ->
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/'))
    )

  all_events: ()->
    this.models
