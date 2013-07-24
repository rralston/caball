$(document).ready ()->

  app.fn.search_event_handler = (search_object) ->
    # window.location.href = "/events?search="+search_object.value
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
        else
          alert 'Something went wrong, Please try again.'
  
  $.widget "custom.catcomplete", $.ui.autocomplete,
    _renderMenu: (ul, items) ->
      that = this
      currentCategory = ""
      $.each items, (index, item) ->
        unless item.category is currentCategory
          ul.append "<li class='ui-autocomplete-category'>" + item.category + "</li>"
          currentCategory = item.category
        that._renderItemData ul, item

  data = [
    { label: "anders", category: "" },
    { label: "andreas", category: "" },
    { label: "antal", category: "" },
    { label: "annhhx10", category: "Products" },
    { label: "annk K12", category: "Products" },
    { label: "annttop C13", category: "Products" },
    { label: "anders andersson", category: "People" },
    { label: "andreas andersson", category: "People" },
    { label: "andreas johnson", category: "People" }
  ]

  $("#search-events-input").catcomplete
    delay: 0
    source: (request, response) ->
      $.getJSON( "http://gd.geobytes.com/AutoCompleteCity?callback=?&q="+request.term, (data) ->
                  # create custom data from the response with category and type
                  custom_data =  _.map(data, (item)-> { label: item, value: item, category: 'Search by Location', type: 'location' } )
                  # pushing the search by keyword option too..
                  custom_data.push({ category: 'Search for Keyword', label: request.term, type: 'keyword' })
                  response(custom_data)
                )
    select: (event, ui) ->
      app.fn.search_event_handler(ui.item)
    messages:
      noResult: ''
      results: ()->

