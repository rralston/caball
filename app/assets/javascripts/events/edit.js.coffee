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


  $('#event_tags').tagit
    sortable: true
    triggerKeys: ['comma', 'tab', 'space', 'enter']
    tagsChanged: (tagValue, action, element) ->
      console.log element
      tag_value_array = _.map($('#event_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#event_tag_list').val(tag_value_array.toString())