$(document).ready ()-> 
  $('#expertise_tags').tagit
    sortable: true
    tagsChanged: (tagValue, action, element) ->
      tag_value_array = _.map($('#expertise_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_expertise').val(tag_value_array.toString())

  app.fn.init_image_crop_handlers()

  app.fn.description_tag_list_init = ()->
    $('#user_description_tags').tagit
      sortable: true
      maxTags: 4
      initialTags: []
      tagsChanged: (tagValue, action, element) ->
        tags_array = _.map($('#user_description_tags').tagit('tags'), (tag) ->
          tag.value
        )
        $('#user_characteristics_attributes_description_tag_list').val(tags_array.toString())

  app.fn.init_image_file_uploader  = (element) ->
    # file upload handler for step 1 form and step 3 form containing image files.
    element.fileupload
      url: '/users/files_upload'
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

          data.image_parent_container = data.control_group_div.find('.image_container')

          data.crop_btn = data.control_group_div.find('.btn.crop_image')

          data.submit()
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

          # update the id value to the value returned by the server.
          data.id_div = data.control_group_div.find('.photo_id_div')
          data.id_div.val(id)

          # remove the numerous-remove link and show object destroy link
          data.control_group_div.find('.numerous-remove').hide()
          data.control_group_div.find('.saved_object_remove_actions').show()

        else
          image_url = data.result


        data.image_container.attr('src', image_url)
        data.image_container.show()
        data.image_parent_container.show()

        if typeof data.result == 'object'
          data.crop_btn.attr('data-orgImgUrl', image_url)
          data.crop_btn.attr('data-prevImgUrl', image_url)
          data.crop_btn.attr('data-orgWidth', data.result['original_width'])
          data.crop_btn.attr('data-orgHeight', data.result['original_height'])
          data.crop_btn.show()

          app.fn.hard_rest_crop_values(data.control_group_div, '150px', '150px')

        app.fn.adjust_slider_height()
        data.progress_div.hide()

  app.fn.init_step_2_fileupload = () ->
    # file upload handler for step 2 form.
    $('#user_edit_form_step_2').fileupload
      url: '/users/files_upload'
      type: 'POST'
      add: (e, data)->
        # e.target gives the form.
        types = /(\.|\/)(doc?x|pdf)$/i
        file = data.files[0]

        # file type verification.
        if types.test(file.type) || types.test(file.name)
          data.progress_div = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.upload_progress')
          data.progress_div.show()

          data.preview_container = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.upload_doc_preview')
          data.preview_container.hide()
          data.submit()
          
          # if the user just uploaded the script document, then show synopsis div
          if data.fileInput.hasClass('script_document')
            $('.script_synopsis').show()

        else
          alert('The file you selected is not a doc, docx or pdf file')
      progress: (e, data)->
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.progress_div.find('.bar').css('width', progress + '%')
      done: (e, data)->
        console.log data
        data.preview_container.attr('href', data.result)
        data.preview_container.show()
        data.progress_div.hide()
        app.fn.adjust_slider_height()

  # this will toggle textboxes based on radio choice,
  # example: do you have an agent.? if yes, show text box.
  app.fn.initialize_radio_toggler()

  app.fn.init_form_elem_hints('.hinted')

  # initialize step_1_form image files uplaoder.
  app.fn.init_image_file_uploader($('#user_edit_form'))


  # handler to remove talents, photos and videos dynamically.!
  $('body').on 'click', '.remove_entity', (event)->
    event.stopPropagation()
    target = $(event.target)

    # find the desctroy checkbox and make it checked.
    check_box = target.parent().find('.destroy_checkbox')
    check_box.attr('checked', true)

    to_remove = target.attr('data-toRemove')
    target.closest(to_remove).hide()
    target.closest(to_remove).removeClass(to_remove.substring(1, to_remove.length)) # to_remove is a class selector, we don't need dot(.) infront of it

    # show the link to add more talents
    $('a#add-to-talents-list').show()
    return false


  # auto complete for user agent
  app.fn.init_agent_name_autocomplete = ()->
    $("#user_agent_name").autocomplete
      delay: 0
      source: (request, response) ->
        $.getJSON "/users/agent_names?q="+request.term, (data)->
          if data.length > 0
            final_data = _.map(data, (user)->
              {
                "label": user.name,
                "value": user.name,
                "id": user.id
              }
            )
          response(final_data)
      select: (event, ui)->
        # update the actual field with the id
        $('#user_agentship_attributes_agent_id').val(ui.item.id)
      messages:
        noResult: ''
        results: ()->

  $('body').on 'click', '.step_1_submit', (event)->
    btn = $(event.target)
    btn.val('Please wait..')
    btn.attr('disabled', 'disabled')
    $.ajax
      type: 'POST'
      url: '/users/step_1'
      data: $('#user_edit_form').serialize()
      success: (data)->
        if data != false
          $("html, body").animate({ scrollTop: 0 }, "slow");
          if btn.hasClass('skip')
            window.location = "/users/profile"
          else
            $('#step_2').html(data)
            app.allow_forward_sliding_till = 2
            $('a.step_2_nav').trigger('click')
            app.fn.description_tag_list_init()
            app.fn.init_step_2_fileupload()
            app.fn.init_agent_name_autocomplete()
            app.fn.description_tag_list_init()
        else
          alert('Please correct form errors')
        if !btn.hasClass('skip')
          btn.val('Next Step')
        btn.attr('disabled', false)

    return false

  $('body').on 'click', '.step_2_submit', (event)->
    btn = $(event.target)
    $.ajax
      type: 'POST'
      url: '/users/step_2'
      data: $('#user_edit_form_step_2').serialize()
      success: (data)->
        if data != false
          $("html, body").animate({ scrollTop: 0 }, "slow");
          if btn.hasClass('skip')
            window.location = "/users/profile"
          else
            $('#step_3').html(data)
            app.allow_forward_sliding_till = 3
            $('a.step_3_nav').trigger('click')
            # initialize numerous js
            Users.Edit.init_numerous()
            # initialize step_3 images file uploader.
            app.fn.init_image_file_uploader($('#user_edit_form_step_3'))
            app.fn.adjust_slider_height()
        else
          alert('Please correct form errors')
        

    return false

  # # step 3 submit handler
  # $('body').on 'submit', '#user_edit_form_step_3', (event)->
  #   $.ajax
  #     type: 'POST'
  #     url: '/users/step_3'
  #     data: $('#user_edit_form_step_3').serialize()
  #     success: (data)->
  #       console.log data
  #       # $('#step_3').html(data)
  #       # $('a.step_3_nav').trigger('click')
  #       # initialize step_3 images file uploader.
  #       # app.fn.init_image_file_uploader('#user_edit_form_step_3')

  #   return false

  app.fn.slide_form = (current)->
    $('#steps').stop().animate { marginLeft: '-' + widths[current-1] + 'px'}, 500, () ->
      $('#formElem').children(':nth-child('+ parseInt(current) +')').find(':input:first').focus();  

