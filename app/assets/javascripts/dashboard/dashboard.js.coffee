$(document).ready ->
  $('#isotope_container').isotope
    itemSelector: '.item'
    animationOptions:
      duration: 750
      easing: 'linear'
      queue: false

  $('.load_more').on 'click', (event)->
    page_number = parseInt($(event.target).attr('data-next'))
    $.ajax
      url: '/activities/load_more'
      data: 
        page_number: page_number
      success: (resp)->
        activity_models = _.map(resp, (json_activity)->
          new app.models.activity(json_activity)
        )
        
        _.each(app.activities_view.new_items_div(activity_models), (activity_div)->
          $('#isotope_container').isotope('insert', activity_div)
        )
        # increment the page number for the load more button
        $(event.target).attr('data-next', ++page_number)