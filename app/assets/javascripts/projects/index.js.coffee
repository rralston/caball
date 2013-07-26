$(document).ready ()->
  $('.slider-wrapper').bxSlider
    auto: true
    useCss: false
    infiniteLoop: true
    pause: 4000
    adaptiveHeight: false
    mode: 'horizontal'
    speed: 1000
    autoHover: true
    pager: false
    nextText:'Prev'
    prevText:' Prev'
    slideMargin: 5

  reset_results = (resp)->
    app.result_projects.reset(resp)
    $('#all_projects').html(app.result_projects_view.render().el)
    $('.btn-load_more').attr('data-next-page', 2)

  # handler called when the user searches for a string in the search bar
  app.fn.search_event_handler = (search_object) ->
    if search_object.value != ''
      $('.search_please_wait').show()
      $.ajax
        url: "/projects.json"
        type: 'GET'
        data:
          search: search_object.value
        success: (resp) ->
          if resp != 'false'
            
            if resp.length > 0
              app.state = 'search'
              app.params_used.search = search_object.value
              app.params_used.type = search_object.type
              reset_results(resp)
            else
              alert('No projects available')

            # $('.search_word').html(search_object.value)

            # if search_object.type == 'location'
            #   $('.search_type').html('Events in: ')
            # else
            #   $('.search_type').html('Events wid keyword: ')
          else
            alert 'Something went wrong, Please try again.'
          # $('.search_please_wait').hide()


  app.fn.initialize_cat_complete_search("#search-projects-input", app.fn.search_event_handler)


  $('body').on 'click', '.btn-load_more', (event)->
    form = $('#projects_search_form')
    btn = $(event.target)
    btn.html('Please Wait..')
    page_number = parseInt(btn.attr('data-next-page'))
    data = {
      status: app.state,
      page: page_number 
    }
    if app.state == 'search'
      form_data = app.fn.serializeJSON(form)
      _.extend(data, form_data)

    $.ajax
      url: 'projects.json'
      data: data

      success: (resp) ->
        if resp != 'false'
          if resp.length > 0
            new_project_models = _.map(resp, (project_json)->
              new app.models.project(project_json)
            )
            if app.state == 'index'
              app.recent_projects.add(new_project_models)
            else
              app.result_projects.add(new_project_models)
            # increment page number on the loadmore button
            btn.attr('data-next-page', ++page_number)
          else
            alert('No more projects available')
            btn.hide()
        else
          alert('Something went wrong, Please try again later')
        btn.html('Load More') 
      

  $('body').on 'click', '#btn-search_projects', ()->

    form = $('#projects_search_form')
    btn = form.find('input[type=submit]')
    app.state = 'search'
    form_data = app.fn.serializeJSON(form)

    data = {
      status: app.state,
      page: 1
    }
    _.extend(data, form_data)

    btn.attr('disabled', 'disabled')
    btn.html('Please Wait..')

    $.ajax
      url: 'projects.json'
      data: data

      success: (resp) ->
        if resp != 'false'
          if resp.length > 0
            reset_results(resp)
          else
            alert('No projects available')
        else
          alert('Something went wrong, Please try again later')
        btn.html('Load More') 

