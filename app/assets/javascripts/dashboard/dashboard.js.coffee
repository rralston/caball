$(document).ready ->

  $('.change_email_form').on 'submit', (event) ->
    errorhtml = "<div class='alert alert-error'><button type='button' class='close' data-dismiss='alert'>&times;</button>\n"
    errormessage = ""
    error_flag = false
    $(this).find('.require').each (input) ->
      if this.value.length == 0
        error_flag = true
        errormessage += "Please fill out "+ this.name + "<br/>"
    if error_flag
      error_display = errorhtml + errormessage + "</div>"
      $('.change_email_form .errors').html(error_display)
      false

  $('.change_password_form').on 'submit', (event) ->
    errorhtml = "<div class='alert alert-error'><button type='button' class='close' data-dismiss='alert'>&times;</button>\n"
    errormessage = ""
    error_flag = false
    $(this).find('.require').each (input) ->
      if this.value.length == 0
        error_flag = true
        errormessage += "Please fill out "+ this.name + "<br/>"
    if error_flag
      error_display = errorhtml + errormessage + "</div>"
      $('.change_password_form .errors').html(error_display)
      false


  $('.load_more').on 'click', (event)->
    type = $(event.target).attr('data-type')
    app.events.trigger(type, event)

  $('body').on 'click', '.send-generic-message', (event)->
    app.fn.show_generic_message_modal(event)

  $('body').on 'click', '.message-applicant', (event)->
    app.fn.show_generic_message_modal(event)

  $('body').on 'click', 'a[href=#projects]', (event)->
    if app.projects_loaded == false
      # fetch and render the user projects
      $.ajax
        url: '/dashboard/projects.json'
        type: 'GET'
        success: (resp)->
          if resp != 'false'
            # user projects
            app.user_projects.reset(resp.user_projects)
            app.applied_projects.reset(resp.applied_projects)

            # render and add views to DOM
            $('#dashboard_projects').html(app.user_projects_view.render().el)
            $('#dashboard_projects').find('#applied-projects').html(app.applied_projects_view.render().el)

            # set projects loaded as true
            app.projects_loaded = true
          else
            alert('Something went wrong, Please try again')
    else
      # rerender and add views to DOM, this is required to go back when user in the 
      # manage project view
      $('#dashboard_projects').html(app.user_projects_view.render().el)
      $('#dashboard_projects').find('#applied-projects').html(app.applied_projects_view.render().el)  

  
  $('body').on 'click', 'a[href=#events]', (event)->
    if app.events_loaded == false
      # fetch and render the user events
      $.ajax
        url: '/dashboard/events.json'
        type: 'GET'
        success: (resp)->
          if resp != 'false'
            # user events
            app.user_events.reset(resp.user_events)
            app.attending_events.reset(resp.attending_events)

            # render and add views to DOM
            $('#dashboard_events').html(app.user_events_view.render().el)
            $('#dashboard_events').find('#attending-events').html(app.attending_events_view.render().el)

            # set events loaded as true
            app.events_loaded = true
          else
            alert('Something went wrong, Please try again')

  $('body').on 'click', 'a[href=#messages]', (event)->
    if app.messages_loaded == false
      # fetch and render the user events
      $.ajax
        url: '/dashboard/conversations.json'
        type: 'GET'
        success: (resp)->
          if resp != 'false'
            # user conversations
            app.inbox_conversations.reset(resp.inbox_conversations)
            app.sent_conversations.reset(resp.sent_conversations)
            app.trash_conversations.reset(resp.trash_conversations)

            # render and add views to DOM
            $('#conversation-tab-inbox').html(inbox_view.render().el)
            $('#conversation-tab-sent').html(sent_view.render().el)
            $('#conversation-tab-trash').html(trash_view.render().el)

            # set conversations loaded as true
            app.messages_loaded = true
          else
            alert('Something went wrong, Please try again')


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