$(document).ready ->

  $('.load_more').on 'click', (event)->
    type = $(event.target).attr('data-type')
    app.events.trigger(type, event)

  $('body').on 'click', '.send-generic-message', (event)->
    app.fn.show_generic_message_modal(event)

  $('body').on 'click', '.message-applicant', (event)->
    app.fn.show_generic_message_modal(event)

  $('body').on 'click', 'a[href=#projects]', (event)->
    $('#dashboard_projects').html(app.user_projects_view.render().el)
    $('#dashboard_projects').find('#applied-projects').html(app.applied_projects_view.render().el)


  app.fn.add_receipient = (selector, email)->
    # div = $('.project_selected_applicants')
    div = $(selector)
    recipients = div.attr('data-message-recipients').split(',')
    recipients.push(email)
    div.attr('data-message-recipients', recipients.join(','))

  app.fn.remove_receipient = (selector, email)->
    # div = $('.project_selected_applicants')
    div = $(selector)
    recipients = div.attr('data-message-recipients').split(',')
    if(recipients.indexOf(email) != -1)
      recipients.splice(recipients.indexOf(email))
      div.attr('data-message-recipients', recipients.join(','))
  
