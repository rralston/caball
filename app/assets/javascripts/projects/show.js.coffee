$(document).ready ()-> 
  
  $('.show_applicants').on 'click', (event) ->
    role_id = $(event.target).data('id')
    $.ajax
      url: '/roles_applicants'
      data:
        role_id: role_id
      type: 'POST'
      success: (resp)->
        $('#show_applicants_modal .applicants_list').html('')
        $('#show_applicants_modal').modal('show')
        applicant_template = _.template($('#applicant_modal_template').html())
        _.each(resp, (applicant) ->
          $('#show_applicants_modal .applicants_list').append(applicant_template(applicant))  
        )
        
  $('body').on 'click', '.select_applicant', (event)->
    btn = $(event.target)
    role_id = btn.data('roleid')
    application_id = btn.data('applicationid')
    btn.attr('disabled', 'disabled')
    app.fn.show_loader_in_div(btn)
    $.ajax
      url: '/role_applications/approve'
      data:
        application_id: application_id
      type: 'POST'
      success: (resp)->
        btn.attr('disabled', false)
        if resp != 'false'
          alert 'Applicant added to the role'
          btn.removeClass('select_applicant').addClass('remove_applicant').html('Remove')
        else
          alert 'Error approving application. Maybe you approved a appilcation for this role already. Please check'

  $('body').on 'click', '.remove_applicant', (event)->
    btn = $(event.target)
    role_id = btn.data('roleid')
    application_id = btn.data('applicationid')
    $.ajax
      url: '/role_applications/un_approve'
      data:
        application_id: application_id
      type: 'POST'
      success: (resp)->
        if resp != 'false'
          alert 'Applicant un approved to the role'
          btn.removeClass('remove_applicant').addClass('select_applicant').html('Select')
        else
          alert 'Error processing application'

  $('body').on 'click', '.btn-like-project', (event)->
    btn = $(event.target)
    owner_id = btn.attr('data-ownerId')
    if app.fn.check_current_user() and app.fn.check_not_same_user(owner_id, "you can't like your own project.")
      btn.html('Please wait..')
      if btn.hasClass('liked')
        $.ajax
          url: '/likes/unlike'
          type: 'POST'
          data:
            like:
              loveable_id: btn.attr('data-projectId')
              loveable_type: 'Project'
          success: (resp) ->
            if resp != 'false'
              btn.removeClass('liked')
              fan = new app.models.fan(app.current_user)
              app.fans.remove(fan)
              btn.html('Become a Fan!')
            else
              alert 'Something went wrong, please try again later'
      else
        $.ajax
          url: '/likes.json'
          type: 'POST'
          data:
            like:
              loveable_id: btn.attr('data-projectId')
              loveable_type: 'Project'
          success: (resp) ->
            if resp != 'false'
              btn.addClass('liked')
              fan = new app.models.fan(app.current_user)
              app.fans.add(fan)
              btn.html("You're a Fan!")
            else
              alert 'Something went wrong, please again try later'

