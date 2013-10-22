app.collections.attending_events = Backbone.Collection.extend
  model: app.models.attending_event

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
    popular_events.reverse()

  nearby_events: ()->
    nearby_events = _.sortBy( this.upcoming_events(), (event_object) ->
      user_lat  = app.current_user.latitude
      user_lon  = app.current_user.longitude
      event_lat = event_object.get('latitude')
      event_lon = event_object.get('longitude')
      distance = app.fn.distance_between_location( user_lat, user_lon, event_lat, event_lon )
      return distance
    )
    nearby_events

