$(document).ready ()->

  $('body').on 'change', "#project_union" , (event)->
    val = $(event.target).val()
    if val == 'WGA'
      $('#wga_terms').show()
    else 
      $('#wga_terms').hide()

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

        app.fn.resize_form()

  app.fn.init_image_file_uploader('#steps form')


  $('body').on 'click', '.step_1_submit', (event)->
    btn = $(event.target)

    form = btn.closest('form')
    if form.isValid(ClientSideValidations.forms[form.attr('id')].validators)
      $.ajax
        type: 'POST'
        url: '/projects/step_1'
        data: $('.step_1_form').serialize()
        success: (data)->
          if data != false
            $("html, body").animate({ scrollTop: 0 }, "slow");
            # if btn.hasClass('skip')
            #   window.location = "/users/profile"
            # else
            $('#step_2').html(data)
            app.allow_forward_sliding_till = 2
            $('a.step_2_nav').trigger('click')
              # app.fn.description_tag_list_init()
              # app.fn.init_step_2_fileupload()
              # app.fn.init_agent_name_autocomplete()
              # app.fn.description_tag_list_init()
          else
            alert('Please correct form errors')
    return false

  $('body').on 'click', '.step_2_submit', (event)->
    btn = $(event.target)
    $.ajax
      type: 'POST'
      url: '/projects/step_2'
      data: $('.step_2_form').serialize()
      success: (data)->
        if data != false
          $("html, body").animate({ scrollTop: 0 }, "slow");
          
          # if btn.hasClass('skip')
          #   window.location = "/users/profile"
          # else
          $('#step_3').html(data)
          app.allow_forward_sliding_till = 3
          $('a.step_3_nav').trigger('click')
          get_ready_for_step_3()
            # # initialize numerous js
            # Users.Edit.init_numerous()
            # # initialize step_3 images file uploader.
            # app.fn.init_image_file_uploader($('#user_edit_form_step_3'))
            # app.fn.adjust_slider_height()
        else
          alert('Please correct form errors')
        
    return false


  app.fn.init_image_crop_handlers()


  # this will toggle textboxes based on radio choice,
  # example: do you have an agent.? if yes, show text box.
  app.fn.initialize_radio_toggler()


  # this function is called once after the step 3 html is loaded from the server and attached to the DOM
  get_ready_for_step_3 = ()->
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

