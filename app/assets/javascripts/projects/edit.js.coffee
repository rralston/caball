$(document).ready ()->

  $('body').on 'change', ".union_select" , (event)->
    val = $(event.target).val()
    if val == 'WGA'
      $('#wga_terms').show()
    else 
      $('#wga_terms').hide()


  app.fn.handle_guilds_dropdown('.union_select', '.union_input')
  app.fn.bind_show_url_name('#project_title','.url_name_summary');

  app.fn.init_image_file_uploader = (selector)->
    $(selector).fileupload
      url: '/projects/files_upload'
      type: 'POST'
      add: (e, data)->
        # e.target gives the form.
        types = /(\.|\/)(jpe?g|png)$/i
        file = data.files[0]
        # file type verification.
        window.file = file
        if types.test(file.type) || types.test(file.name) 
          if file.size < 10485760
            data.progress_div = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.upload_progress')
            data.progress_div.show()

            data.control_group_div =  $('#' + data.fileInput.attr('id')).closest('.control-group')

            data.image_container = data.control_group_div.find('.image_preview_container')
            data.image_container.attr('src', '')

            data.crop_btn = data.control_group_div.find('.btn.crop_image')
            data.submit()
          else
            alert('File size should be less than 10MB')
        else
          alert('The file you selected is not a jpeg or png image file')
      progress: (e, data)->
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.progress_div.find('.bar').css('width', progress + '%')
      done: (e, data)->
        if typeof data.result == 'object' && _.size(data.result) > 1
          # > 1 when a hash is returned with id of the newly created object.
          image_url = data.result['url']
          id = data.result['id']

          # update the image field with url
          data.url_field = data.control_group_div.find('.photo_url_div')
          data.url_field.val(image_url)
          
          # remove the numerous-remove link and show object destroy link
          data.control_group_div.find('.numerous-remove').hide()
          data.control_group_div.find('.saved_object_remove_actions').show()

        else
          image_url = data.result

        data.image_container.attr('src', image_url)
        data.image_container.show()
        data.control_group_div.find('.image_container').show()

        app.fn.adjust_slider_height()
        data.progress_div.hide()
        if typeof data.result == 'object'
          data.crop_btn.attr('data-orgImgUrl', image_url)
          data.crop_btn.attr('data-prevImgUrl', image_url)
          data.crop_btn.attr('data-orgWidth', data.result['original_width'])
          data.crop_btn.attr('data-orgHeight', data.result['original_height'])
          data.crop_btn.show()

          app.fn.hard_rest_crop_values(data.control_group_div, '150px', '150px')

        # if any error message for not uploading image is present., remove it.
        data.control_group_div.find('.photo_required_error').remove()
        
        app.fn.resize_form()

  app.fn.init_image_file_uploader('#steps form')


  # Remove hints if user leaves div
  $(".hinted").focusout ->
    $(".hint_msg").hide()

  $('body').on 'click', '.step_1_submit', (event)->
    btn = $(event.target)

    form = btn.closest('form')
    if form.isValid(ClientSideValidations.forms[form.attr('id')].validators) && app.fn.check_if_photo_uploaded('.photo_url_div')
      btn = $('input.step_1_submit')
      btn.val('Please wait..')
      btn.attr('disabled', 'disabled')
      $.ajax
        type: 'POST'
        url: '/projects/step_1'
        data: $('.step_1_form').serialize()
        success: (data)->
          if data != false
            $("html, body").animate({ scrollTop: 0 }, "slow");

            $('#step_2').html(data)
            app.allow_forward_sliding_till = 2
            $('a.step_2_nav').trigger('click')

            get_ready_for_last_step()
          else
            alert('Please correct form errors')
          btn.val('Next Step')
          btn.attr('disabled', false)
    else
      alert('You have form errors, Please verify')
      
      if $('.field_with_errors').size() > 0
        $("html, body").animate({ scrollTop: $('.field_with_errors').offset().top }, "slow")
      else
        $("html, body").animate({ scrollTop: 0 }, "slow")

    return false


  app.fn.init_image_crop_handlers()


  # this will toggle textboxes based on radio choice,
  # example: do you have an agent.? if yes, show text box.
  app.fn.initialize_radio_toggler()


  # this function is called once after the step 3 html is loaded from the server and attached to the DOM
  get_ready_for_last_step = ()->
    # prevents creation of multiples object when user is sliding back and front in the form.
    if typeof app.project_roles == 'undefined'
      app.project_roles = new app.collections.project_roles(app.project_added_roles)
      app.project_roles_view = new app.views.project_roles({ collection: app.project_roles })

    $('#add_roles_div').append(app.project_roles_view.render().el)

    # create a new project role model and a edit view for it to show the form
    app.project_role = new app.models.project_role()
    app.project_role_edit_view = new app.views.project_role_edit({model: app.project_role})



    $('#role_edit_region').html(app.project_role_edit_view.render().el)

    app.fn.adjust_slider_height()


  # this funtion is used to show only roles that the selected user has while adding him to team.
  app.fn.filter_roles = (all_roles_object, to_have_roles_array) ->
    to_show_roles = _.invert(all_roles_object)
    to_show_roles = _.pick(to_show_roles, to_have_roles_array)
    _.invert(to_show_roles)


  $(document).on 'CastRoleSelected', (event) ->
    # show cast role options only when the role doesn't have a user selected.
    
    $(event.target).closest('.control-group').find('.cast_role_options').show();

    if $('.role_user_id').size() > 0 && $('.role_user_id').val() != null
      $(event.target).closest('.control-group').find('.cast_role_options').find('.options_1').hide()        

  $(document).on 'NonCastRoleSelected', (event) ->
    $(event.target).closest('.control-group').find('.cast_role_options').hide();

