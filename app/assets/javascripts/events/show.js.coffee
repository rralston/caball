$(document).ready ()->
  $('body').on 'click', '.btn-attend', (event)->
    btn = $(event.target)
    request = 'attend'
    btn.html('Please Wait..')
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
            # create a new backbone model and remove from collection
            attendee = new app.models.attendee(resp)
            app.attendees.remove(attendee)
          else
             btn.html('Attending').addClass('unattend')
             # create a new backbone model and add to collection
             attendee = new app.models.attendee(resp)
             app.attendees.add(attendee)
        else
          alert 'Something went wrong. Please try later'

  $('body').on 'click', '.btn-like', (event) ->
    btn = $(event.target)
    url = '/likes.json'
    btn.html('Please Wait..')
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

  $('body').on 'click', '.btn-invite-followers', (event) ->
    btn = $(event.target)
    btn.html('Please Wait..')
    $.ajax
      url: '/events/invite_followers'
      type: 'POST'
      data: 
        event_id: btn.attr('data-event-id')
      success: (resp)->
        if resp != false
          alert 'invited all your followers'
        else
          alert 'Something went wrong. Please try later'
        btn.html('Invite Followers')