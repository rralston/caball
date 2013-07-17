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
