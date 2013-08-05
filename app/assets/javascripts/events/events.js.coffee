$(document).ready ()->

  app.fn.search_event_handler = (search_object) ->
    if search_object.value != ''
      $('.search_please_wait').show()
      $.ajax
        url: "/events.json"
        type: 'GET'
        data:
          search: search_object.value
        success: (resp) ->
          if resp != 'false'
            # reset the respective collections.
            app.popular_events.reset(resp.popular_events)
            app.new_events.reset(resp.new_events)
            app.by_date_events.reset(resp.events_by_time)
            app.params_used.search = search_object.value
            app.params_used.type = search_object.type

            $('.search_word').html(search_object.value)

            if search_object.type == 'location'
              $('.search_type').html('Events in: ')
            else
              $('.search_type').html('Events wid keyword: ')
          else
            alert 'Something went wrong, Please try again.'
          $('.search_please_wait').hide()
          
  app.fn.initialize_cat_complete_search("#search-events-input", app.fn.search_event_handler)
  