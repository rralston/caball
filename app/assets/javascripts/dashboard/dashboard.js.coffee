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


  # hide notification division when clicked on the cross icon in the notifications tab
  $('body').on 'click', '#notifications_tab .hide-me', (event)->
    
    # get and update new notifications count
    prev_count = $('#notifications_tab .notif_summary .count').html()
    $('#notifications_tab .notif_summary .count').html( parseInt(prev_count) - 1)

    # update in the main button also.
    $('.notifications-summary .count').html( parseInt(prev_count) - 1)

    $(event.target).closest('.notification').hide()
  
  $('body').on 'click', '#notif_tab_link', (event)->
    if $('#notif_tab_link').hasClass('set_time')
      app.fn.set_notification_check_time($('#notif_tab_link'))

  $('body').on 'click', '.notifications-summary .btn-notification', (event)->
    $('#notif_tab_link').trigger('click')

  $('body').on 'click', '.btn-notification .ignore-btn', (event) ->
    event.stopPropagation()
    # mark notification seen time for the user when he clicks on the ignore notificaitons cross icon
    if $('.btn-notification .ignore-btn').hasClass('set_time')
      app.fn.set_notification_check_time($('.btn-notification .ignore-btn'))
