app.collections.user_events = Backbone.Collection.extend
  model: app.models.user_event

  past_events: ()->
    past_event = _.filter(this.models, (event_object) -> 
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/')) < Date.parse(Date())
    )
    past_event

  current_events: ()->
    upcoming_event = _.filter(this.models, (event_object) ->
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/')) > Date.parse(Date())
    )
    
    _.sortBy( upcoming_event, (event_object) ->
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/'))
    )

  all_events: ()->
    this.models