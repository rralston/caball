$(document).ready ()-> 
  $('#expertise_tags').tagit
    sortable: true
    tagsChanged: (tagValue, action, element) ->
      tag_value_array = _.map($('#expertise_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_expertise').val(tag_value_array.toString())

  $('#user_description_tags').tagit
    sortable: true
    initialTags: []
    tagsChanged: (tagValue, action, element) ->
      tags_array = _.map($('#user_description_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_characteristics_attributes_description_tag_list').val(tags_array.toString())

  app.fn.initialize_radio_toggler()

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
        $('a[href=#step_2]').trigger('click')

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
        data.submit()
      else
        alert('The file you selected is not a gif, jpeg or png image file')
    progress: (e, data)->
      progress = parseInt(data.loaded / data.total * 100, 10)
      data.progress_div.find('.bar').css('width', progress + '%')
    done: (e, data)->
      console.log data
      # data.progress_div.hide()