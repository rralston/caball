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
        if types.test(file.type) || types.test(file.name)
          data.progress_div = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.upload_progress')
          data.progress_div.show()

          data.control_group_div =  $('#' + data.fileInput.attr('id')).closest('.control-group')

          data.image_container = data.control_group_div.find('.image_preview_container')
          data.image_container.attr('src', '')
          data.submit()
        else
          alert('The file you selected is not a jpeg or png image file')
      progress: (e, data)->
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.progress_div.find('.bar').css('width', progress + '%')
      done: (e, data)->
        console.log data.result
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
        app.fn.adjust_slider_height()
        data.progress_div.hide()
        if typeof data.result == 'object'
          app.fn.init_jcrop(data.image_container, data.control_group_div, data.result['original_width'], data.result['original_height'])
        app.fn.resize_form()

  app.fn.init_image_file_uploader('#steps form')


  $('body').on 'click', '.step_1_submit', (event)->
    btn = $(event.target)
    $.ajax
      type: 'POST'
      url: '/projects/step_1'
      data: $('.project-save-form').serialize()
      success: (data)->
        if data != false
          $("html, body").animate({ scrollTop: 0 }, "slow");
          alert('submitteed');
          # if btn.hasClass('skip')
          #   window.location = "/users/profile"
          # else
          #   $('#step_2').html(data)
          #   app.allow_forward_sliding_till = 2
          #   $('a.step_2_nav').trigger('click')
          #   app.fn.description_tag_list_init()
          #   app.fn.init_step_2_fileupload()
          #   app.fn.init_agent_name_autocomplete()
          #   app.fn.description_tag_list_init()
        else
          alert('Please correct form errors')

    return false

