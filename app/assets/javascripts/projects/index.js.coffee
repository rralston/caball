$(document).ready ()->

  app.fn.extend_params_data = (data)->
    form = $('#projects_search_form')

    form_data = app.fn.jquerySerailize(form)
    _.extend(data, form_data)

    if typeof data.distance != 'undefined' && data.distance != ''
      data['location'] = app.current_user_location

    # if something was searched in the search bar previously, preserve it and apply filters on it.
    if app.params_used and app.params_used.search
      data[app.params_used.type] = app.params_used.search

    data

  

  reset_results = (resp)->
    app.result_projects.reset(resp)
    $('#all_projects').html(app.result_projects_view.render().el)
    $('.btn-load_more').attr('data-next-page', 2)

  

  # handler called when the user searches for a string in the search bar
  app.fn.search_event_handler = (search_object) ->
    if search_object.value != ''
      $('.search_please_wait').show()

      type = search_object.type

      if type == 'location'
        data = {
          location: search_object.value,
          load_type: 'search',
          page: 1
        }
      else
        data = {
          search: search_object.value,
          load_type: 'search',
          page: 1
        }
      $('.search_please_wait').show()
      $.ajax
        url: "/projects.json"
        type: 'GET'
        data: data
        success: (resp) ->
          if resp != 'false'
            
            if resp.length > 0
              app.status = 'search'
              app.params_used = {}
              app.params_used.search = search_object.value
              app.params_used.type = search_object.type
              reset_results(resp)
              $('#projects_search_form')[0].reset()
              if type == 'location'
                $('.search_filters').html('<div class="badge badge-custom-green">location: '+search_object.value+'</div>');
              else
                $('.search_filters').html('<div class="badge badge-custom-green">keyword: '+search_object.value+'</div>');
            else
              alert('No projects available')
          else
            alert 'Something went wrong, Please try again.'
          $('.search_please_wait').hide()


  app.fn.initialize_cat_complete_search("#search-projects-input", app.fn.search_event_handler)


  $('body').on 'click', '.btn-load_more', (event)->
    form = $('#projects_search_form')
    btn = $(event.target)
    btn.html('Please Wait..')
    page_number = parseInt(btn.attr('data-next-page'))
    
    # initialize data
    data = {
      status: app.status,
      page: page_number,
      load_type: 'recent'
    }
    
    # if status is searching, then take the form elements and put in params.
    if app.status == 'search'
      data.load_type = 'search'
      data = app.fn.extend_params_data(data)

    $.ajax
      url: '/projects.json'
      data: data

      success: (resp) ->
        if resp != 'false'
          if resp.length > 0
            new_project_models = _.map(resp, (project_json)->
              new app.models.project(project_json)
            )
            if app.status == 'index'
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
      
  # Add search filters after the search was succesful
  app.fn.add_filters = (data_hash) ->
    delete data_hash["page"]
    delete data_hash["load_type"]
    $('.search_filters').html("")
    for key,val of data_hash
      if val
        $('.search_filters').append('<div class="badge badge-custom-green">'+key+': '+val+'</div>');

  $('body').on 'click', '#btn-search_projects', ()->
    $('.search_please_wait').show()
    form = $('#projects_search_form')
    btn = form.find('input[type=submit]')

    app.status = 'search'

    data = {
      page: 1,
      load_type: 'search'
    }

    data =  app.fn.extend_params_data(data)

    btn.attr('disabled', 'disabled')
    btn.html('Please Wait..')

    $.ajax
      url: '/projects.json'
      data: data

      success: (resp) ->
        if resp != 'false'
          if resp.length > 0
            reset_results(resp)
            app.fn.add_filters(data)
          else
            alert('No projects available')
        else
          alert('Something went wrong, Please try again later')
        btn.html('Search') 
        $('.search_please_wait').hide()

