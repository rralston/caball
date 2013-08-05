$(document).ready ()->
  
  $('body').on 'click', '.btn-attend', (event)->
    btn = $(event.target)
    request = 'attend'
    if btn.hasClass('unattend')
      request = 'unattend'

    if app.current_user != null
      btn.html('Please Wait..')
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
    if btn.hasClass('unlike')
      request = 'unlike'
      url = '/likes/unlike.json'

    if app.current_user != null
      $('.btn-like').find('.text').html('Wait..')
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
              $('.btn-like').find('.text').html('Like this').removeClass('unlike')
            else
              $('.btn-like').find('.text').html('Un Like').addClass('unlike')
          else
            alert 'Something went wrong. Please try later'

  $('body').on 'click', '.btn-send-message', (event) ->
    btn = $(event.target)
    message = $('#conversation_body').val()
    if message != ''
      if app.current_user != null
        btn.html('Please Wait..')
        $.ajax
          url: '/events/message_organizer'
          type: 'POST'
          data: 
            message: message
            event_id: btn.attr('data-event-id')
          success: (resp)->
            console.log resp
            if resp != 'false'
              alert 'Message Sent'
              $('#message_event_organizer_modal').modal('hide')
            else
              alert 'Something went wrong. Please try later'
            btn.html('Send Message')
    else
      alert('Please enter messge')

  $('body').on 'click', '.btn-invite-followers', (event) ->
    btn = $(event.target)
    if app.current_user != null
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