$(document).ready ()-> 
  $('#expertise_tags').tagit
    sortable: true
    maxTags: 4
    tagsChanged: (tagValue, action, element) ->
      tag_value_array = _.map($('#expertise_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_expertise').val(tag_value_array.toString())


  app.fn.init_image_crop_handlers()
  app.fn.handle_guilds_dropdown('.guild_select', '.guild_input')
  app.fn.bind_show_url_name('#user_name','.url_name_summary')

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
          data.destroy_checkbox = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.destroy_checkbox')
          data.preview_parent = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.upload-doc-parent') 

          data.destroy_checkbox.attr('checked', false)
          
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
        
        data.preview_container.attr('href', data.result.link)
        data.preview_container.html(data.result.name)
        data.preview_container.show()
        data.preview_parent.show()
        # find the desctroy checkbox and make it un checked.
        data.destroy_checkbox.attr('checked', false)
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

    # remove the super_role_select class on the select since it is used in triggering FanSelection events and might mess things up if present
    target.closest(to_remove).find('.super_role_select').removeClass('super_role_select')

    target.closest(to_remove).hide()

    target.closest(to_remove).removeClass(to_remove.substring(1, to_remove.length)) # to_remove is a class selector, we don't need dot(.) infront of it

    app.fn.check_and_trigger_fan_selection()
    # show the link to add more talents
    # $('a#add-to-talents-list').show()
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

    if( $('.super_role_select').size() > 0 )
      btn = $(event.target)
      btn.val('Please wait..')
      btn.attr('disabled', 'disabled')
      $.ajax
        type: 'POST'
        url: '/users/step_1'
        data: $('#user_edit_form').serialize()
        success: (data)->
          # if object, that has some error messages
          if typeof data != 'object'
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
            alert(data.message)
          if !btn.hasClass('skip')
            btn.val('Next Step')
          btn.attr('disabled', false)
    else
      alert('Please select atleast one role.')
      $('.all-roles-container').addClass('have_error')

    return false

  $('body').on 'click', '.step_2_submit', (event)->
    btn = $(event.target)
    $.ajax
      type: 'POST'
      url: '/users/step_2'
      data: $('#user_edit_form_step_2').serialize()
      success: (data)->
        # if object, that has some error messages
        if typeof data != 'object'
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
          alert(data.message)
        

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

  $(document).on 'FanSelection', (event) ->
    if $('.user-talent').size() > 1
      # remove the role if second one is already saved.
      $('.user-talent:nth(1)').find('.remove_entity').trigger('click')
    
    if( $('.super_role_select').size() > 1 )
      # if there are two sub roles in view
      # remove the second role if it was added
      $('#talents-list').find('.numerous-remove:last').trigger('click')

    # hide the option to add one more talent
    $('#add-to-talents-list').hide()

    # hide the next step button
    $('input.step_1_submit:not(.skip)').hide()

    $('.hide_for_fans').hide()
    $('.fan_unhint').removeClass('hinted')

    $('#skills_label').html('Types of films you like')
    $('#step_1_submit_hint').html('Fans need only one step! You are ready to explore Filmzu!')

    app.fn.adjust_slider_height()

  $(document).on 'NonFanSelection', (event) ->

    if( $('.super_role_select').size() < 2 )
      # show the option to add more talent if the value is less than limit
      $('#add-to-talents-list').show()

    $('input.step_1_submit:not(.skip)').show()
    $('#skills_label').html('Skills')
    $('.hide_for_fans').show()
    $('.fan_unhint').addClass('hinted')
    $('#step_1_submit_hint').html("You are almost done! Go to the next page to enter the fun stuff! Or you can check out profile and enter the rest of the stuff later")

    app.fn.adjust_slider_height()
