app.collections.user_events = Backbone.Collection.extend
  model: app.models.user_event

  past_events: ()->
    past_events = _.filter(this.models, (event_object) -> 
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/')) < Date.parse(Date())
    )
    return past_events

  upcoming_events: ()->
    upcoming_events = _.filter(this.models, (event_object) ->
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/')) > Date.parse(Date())
    )
    
    _.sortBy( upcoming_events, (event_object) ->
      return Date.parse(event_object.get('start').date_time.replace(/-/g,'/'))
    )

  popular_events: ()->
    popular_events = _.sortBy( this.upcoming_events(), (event_object) ->
      return event_object.get('attendees').length
    )
    return popular_events.reverse()

