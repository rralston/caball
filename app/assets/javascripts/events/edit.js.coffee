$(document).ready ()->
  app.fn.initalize_location_click_handler('#locate', 'input#event_location')

  app.fn.bind_show_url_name('#event_title','.url_name_summary');

  Numerous.init
    'other_important_dates-list':
      'add' : (added_form_element)->
        window.xy = added_form_element
        app.fn.initialize_date_picker('.date_field')
        app.fn.initialize_time_autocomplete(added_form_element.find('.time_field'))
        $('.new_event').enableClientSideValidations();
        $('.edit_event').enableClientSideValidations();
      'remove': ()->
        $('.new_event').enableClientSideValidations();
        $('.edit_event').enableClientSideValidations();
    'event_photos-list':
      'add' : (added_form_element)->
        app.fn.init_image_file_uploader(added_form_element.find('input[type=file]'))
      
        
  # app.fn.initialize_date_picker('.date_field')
  app.fn.add_chained_datepicker('#event_start_attributes_date', '#event_end_attributes_date')
  app.fn.initialize_time_autocomplete($('.time_field'))

  app.fn.init_image_crop_handlers()

  $('#event_tags').tagit
    sortable: true
    maxTags: 4
    triggerKeys: ['comma', 'tab', 'space', 'enter']
    tagsChanged: (tagValue, action, element) ->
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


  # event photo and other form validations handler
  $('body').on 'click', 'input[type=submit]', (event) ->
    form = $(event.target).closest('form')
    if form.isValid(ClientSideValidations.forms[form.attr('id')].validators) && app.fn.check_if_photo_uploaded('.photo_url_div')
      return true
    else
      alert('Please correct the form errors')
      if $('.field_with_errors').size() > 0
        $("html, body").animate({ scrollTop: $('.field_with_errors').offset().top }, "slow")
      else
        $("html, body").animate({ scrollTop: $('.message.error').parent().offset().top }, "slow")
      return false

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

    return false

