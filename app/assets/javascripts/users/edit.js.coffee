$(document).ready ()-> 
  $('#expertise_tags').tagit
    sortable: true
    tagsChanged: (tagValue, action, element) ->
      tag_value_array = _.map($('#expertise_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_expertise').val(tag_value_array.toString())

  app.fn.description_tag_list_init = ()->
    $('#user_description_tags').tagit
      sortable: true
      initialTags: []
      tagsChanged: (tagValue, action, element) ->
        tags_array = _.map($('#user_description_tags').tagit('tags'), (tag) ->
          tag.value
        )
        $('#user_characteristics_attributes_description_tag_list').val(tags_array.toString())

  # this will toggle textboxes based on radio choice,
  # example: do you have an agent.? if yes, show text box.
  app.fn.initialize_radio_toggler()

  app.fn.init_form_elem_hints('.hinted')

  $('body').on 'click', '.remove_entity', (event)->
    event.stopPropagation()
    target = $(event.target)
    check_box = target.parent().find('.destroy_checkbox')
    check_box.attr('checked', true)
    to_remove = target.attr('data-toRemove')
    target.closest(to_remove).hide()
    target.closest(to_remove).removeClass(to_remove.substring(1, to_remove.length)) # to_remove is a class selector, we don't need dot(.) infront of it
      # show the link to add more talents
    $('a#add-to-talents-list').show()
    return false

  # auto complete for user agent
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

  # step 1 submit handler
  $('body').on 'submit', '#user_edit_form', (event)->
    btn = $(event.target)
    btn.val('Please wait..')
    $.ajax
      type: 'POST'
      url: '/users/step_1'
      data: $('#user_edit_form').serialize()
      success: (data)->
        $('#step_2').html(data)
        $('a.step_2_nav').trigger('click')
        app.fn.description_tag_list_init()
        app.fn.init_step_2_fileupload()

    return false

  # step 2 submit handler
  $('body').on 'submit', '#user_edit_form_step_2', (event)->
    $.ajax
      type: 'POST'
      url: '/users/step_2'
      data: $('#user_edit_form_step_2').serialize()
      success: (data)->
        console.log data
        # $('#step_2').html(data)
        # $('a[href=#step_2]').trigger('click')

    return false


  # file upload handler for step 1 form.
  $('#user_edit_form').fileupload
    url: '/users/files_upload'
    type: 'POST'
    add: (e, data)->
      # e.target gives the form.
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      # file type verification.
      if types.test(file.type) || types.test(file.name)
        data.progress_div = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.upload_progress')
        data.progress_div.show()

        data.image_container = $('#' + data.fileInput.attr('id')).closest('.control-group').find('.image_preview_container')
        data.submit()
      else
        alert('The file you selected is not a gif, jpeg or png image file')
    progress: (e, data)->
      progress = parseInt(data.loaded / data.total * 100, 10)
      data.progress_div.find('.bar').css('width', progress + '%')
    done: (e, data)->
      console.log data
      data.image_container.attr('src', data.result)
      data.image_container.show()
      # data.progress_div.hide()

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
        # data.progress_div.hide()