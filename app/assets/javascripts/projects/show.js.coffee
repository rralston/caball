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
          alert 'Error approving application. May be you approved a appilcation for this role already. Please check'

  $('body').on 'click', '.remove_applicant', (event)->
    btn = $(event.target)
    console.log btn
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

