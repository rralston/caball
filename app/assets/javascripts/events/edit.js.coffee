$(document).ready ()->
  app.fn.initalize_location_click_handler('#locate', 'input#event_location')

  Numerous.init
    'other_important_dates-list':
      'add' : ()->
        app.fn.initialize_datetime_picker('.date_time_field')
        $('.new_event').enableClientSideValidations()
      'remove': ()->
        console.log "in remove"
        $('.new_event').enableClientSideValidations();

  app.fn.initialize_datetime_picker('.date_time_field')