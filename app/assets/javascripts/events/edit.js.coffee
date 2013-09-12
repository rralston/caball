$(document).ready ()->
  app.fn.initalize_location_click_handler('#locate', 'input#event_location')

  Numerous.init
    'other_important_dates-list':
      'add' : (added_form_element)->
        window.xy = added_form_element
        app.fn.initialize_date_picker('.date_field')
        app.fn.initialize_time_autocomplete(added_form_element.find('.time_field'))
        $('.new_event').enableClientSideValidations();
      'remove': ()->
        $('.new_event').enableClientSideValidations();
    'event_photos-list':
      'add' : (added_form_element)->
        app.fn.init_image_file_uploader(added_form_element.find('input[type=file]'))
      
        
  app.fn.initialize_date_picker('.date_field')
  app.fn.initialize_time_autocomplete($('.time_field'))

  app.fn.init_image_crop_handlers()

  $('#event_tags').tagit
    sortable: true
    maxTags: 4
    triggerKeys: ['comma', 'tab', 'space', 'enter']
    tagsChanged: (tagValue, action, element) ->
      console.log element
      tag_value_array = _.map($('#event_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#event_tag_list').val(tag_value_array.toString())

  app.fn.init_image_file_uploader = (selector)->
    $(selector).fileupload
      url: '/events/files_upload'
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

          data.crop_btn = data.control_group_div.find('.btn.crop_image')

          data.submit()
        else
          alert('The file you selected is not a jpeg or png image file')
      progress: (e, data)->
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.progress_div.find('.bar').css('width', progress + '%')
      done: (e, data)->
        console.log data
        app.data= data
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
          data.crop_btn.attr('data-orgImgUrl', image_url)
          data.crop_btn.attr('data-prevImgUrl', image_url)
          data.crop_btn.attr('data-orgWidth', data.result['original_width'])
          data.crop_btn.attr('data-orgHeight', data.result['original_height'])
          data.crop_btn.show()

          app.fn.hard_rest_crop_values(data.control_group_div, '150px', '150px')


  app.fn.init_image_file_uploader('form.edit_event, form.new_event')
