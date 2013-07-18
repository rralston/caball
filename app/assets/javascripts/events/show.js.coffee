$(document).ready ()->
  $('body').on 'click', '.btn-attend', (event)->
    btn = $(event.target)
    request = 'attend'
    
    if btn.hasClass('unattend')
      request = 'unattend'

    $.ajax
      url: '/events/'+request
      type: 'POST'
      data:
        id: btn.attr('data-event-id')
      success: (resp) ->
        if resp != 'false'
          if btn.hasClass('unattend')
            btn.html('Attend').removeClass('unattend')
          else
             btn.html('Attending').addClass('unattend')
        else
          alert 'Something went wrong. Please try later'

  $('body').on 'click', '.btn-like', (event) ->
    btn = $(event.target)
    url = '/likes.json'

    if btn.hasClass('unlike')
      request = 'unlike'
      url = '/likes/unlike.json'

    $.ajax
      url: url
      type: 'POST'
      data: 
        like:
          loveable_type: 'Event'
          loveable_id: btn.attr('data-event-id')
      success: (resp)->
        if resp != false
          if btn.hasClass('unlike')
            btn.html('Like this').removeClass('unlike')
          else
            btn.html('Un Like').addClass('unlike')
        else
          alert 'Something went wrong. Please try later'