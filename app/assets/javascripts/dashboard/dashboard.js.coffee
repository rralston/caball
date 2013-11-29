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
            # user managin projects
            app.user_managing_projects.reset(resp.user_managing_projects)
            # user applied projects
            app.applied_projects.reset(resp.applied_projects)

            # render and add views to DOM
            $('#dashboard_projects').html( app.user_projects_view.render().el )
            $('#dashboard_projects').find('#user-managing-projects').html( app.user_managing_projects_view.render().el )
            $('#dashboard_projects').find('#applied-projects').html(app.applied_projects_view.render().el)

            # set projects loaded as true
            app.projects_loaded = true
            
            app.fn.try_project_intro()

          else
            alert('Something went wrong, Please try again')
    else
      # rerender and add views to DOM, this is required to go back when user in the 
      # manage project view
      $('#dashboard_projects').html(app.user_projects_view.render().el)
      $('#dashboard_projects').find('#user-managing-projects').html( app.user_managing_projects_view.render().el )
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


  loading_div_fn = ()->
    $('<div>').addClass('dashboard_section_loading text-center').html('Loading...<br/><img src="/assets/ajax-loader-bar.gif">')

  fetch_messages_and_show = (type)->
    loading_div = loading_div_fn
    
    $('#conversation-tab-inbox').html(loading_div)
    $('#conversation-tab-sent').html(loading_div)
    $('#conversation-tab-trash').html(loading_div)

    $.ajax
      url: '/dashboard/conversations.json'
      data:
        type: type
      type: 'GET'
      success: (resp)->
        if resp != 'false'
          
          if type == 'inbox'
            app.inbox_conversations.reset(resp.inbox_conversations)
            $('#conversation-tab-inbox').html(inbox_view.render().el)
          
          else if type == 'sent'
            app.sent_conversations.reset(resp.sent_conversations)
            $('#conversation-tab-sent').html(sent_view.render().el)
          
          else if type == 'trash'
            app.trash_conversations.reset(resp.trash_conversations)
            $('#conversation-tab-trash').html(trash_view.render().el)

          app.messages_loaded = true

        else
          alert('Something went wrong, Please try again')

  $('body').on 'click', 'a[href=#messages]', (event)->
    if app.messages_loaded == false
      fetch_messages_and_show('inbox')

  $('body').on 'click', 'a[href=#conversation-tab-sent]', (event) ->
    fetch_messages_and_show('sent')

  $('body').on 'click', 'a[href=#conversation-tab-inbox]', (event) ->
    fetch_messages_and_show('inbox')

  $('body').on 'click', 'a[href=#conversation-tab-trash]', (event) ->
    fetch_messages_and_show('trash')


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