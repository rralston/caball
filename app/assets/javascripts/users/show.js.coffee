# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
#
# CoffeeScript for Users Controller

app.fn.ajax_update = (event, data, call_back) ->
  $(event.target).attr('disabled', 'disabled')
  $.ajax
      url: '/users/update'
      type: 'POST'
      data:
        id: app.current_user.id
        user: data
      success: (resp) ->
        call_back(resp)


$(document).ready ->

  app.fn.initialize_send_generic_message()

  $('body').on 'click', '.btn-follow', (event) ->
    btn = $(event.target)
    friendId = parseInt(btn.attr('data-friend-id'))
    
    if app.fn.check_current_user() and app.fn.check_not_same_user(friendId, "You can't follow yourself.")
      btn.html('Please wait..')
      url = '/friendships'

      if btn.hasClass('unfollow')
        url = '/friendships/destroy'
        
      $.ajax
        url: url
        type: 'POST'
        data:
          friend_id: friendId
        success: (resp)->
          if resp != 'false'
            
            # if it is a follow action add unfollow class
            if btn.hasClass('unfollow')
              btn.html('Follow')
              btn.removeClass('unfollow')
              # set the data-can attr on endorse to false, because he can't endorse this user
              $('.btn-endorse').attr('data-can', 'false')
              fan_model = new app.models.user_fan(JSON.parse(resp.follower))
              app.user_fans.remove(fan_model)
            else
              btn.html('Un Follow')
              btn.addClass('unfollow')
              # set the data-can attr on endorse to false, he can now endorse this user
              $('.btn-endorse').attr('data-can', 'true')
              # add it to the models
              new_fan_model = new app.models.user_fan(JSON.parse(resp.follower))
              app.user_fans.add(new_fan_model)
            $('.flwrs .count').html(resp.followers_count)
            Alert.newAlert("notice", resp.notice);

          else
            alert('Something went wrong, Please try again.')

  $('body').on 'click', '.btn-endorse', (event)->
    if app.fn.check_current_user
      btn = $('.btn-endorse')
      # can tell if the user can endorse.(i.e., that if he is following the user or not)
      can = btn.attr('data-can')
      if can == 'false'
        alert('You need to follow this user to leave an endorsement')
      else
        can2 = btn.attr('data-can2')
        if can2 == 'false'
          alert('This user needs to follow you for you to leave an endorsement')
        else
          $('#endorsement_modal').modal('show')

   $('body').on 'click', '.btn-skills', (event)->
    $('#edit_skills_modal').modal('show')

  $('body').on 'click', '.edit_headline', (event)->
    $('.user_headline_text').hide()
    $('.edit_headline_input').show()

  $('body').on 'click', '.edit_about', (event)->
    $('.user_about_text').hide()
    $('.edit_about_input').show()

  $('body').on 'click', '.edit_headline_input .icon-remove-sign', (event)->
    $('.user_headline_text').show()
    $('.edit_headline_input').hide()

  $('body').on 'click', '.edit_about_input .icon-remove-sign', (event)->
    $('.user_about_text').show()
    $('.edit_about_input').hide()

  $('body').on 'keypress', '#edit_headline', (event)->
    # check if enter is pressed.
    if event.which == app.constants.enter_key_code
      hash = {}
      hash["headline"] = $(event.target).val()
      app.fn.ajax_update event, hash, (resp) ->
        if resp != 'false'
          $('.user_headline_text').show()
          $('.edit_headline_input').hide()
          $('.headline_content').html($(event.target).val())
        else
          alert('Something went wrong, Please try again later')
        $(event.target).attr('disabled', false)

  $('body').on 'keypress', 'textarea#edit_about', (event)->
    # check if enter is pressed.
    if event.which == app.constants.enter_key_code
      hash = {}
      hash["about"] = $(event.target).val()
      app.fn.ajax_update event, hash, (resp) ->
        if resp != 'false'
          $('.user_about_text').show()
          $('.edit_about_input').hide()
          $('.about_content').html($(event.target).val())
        else
          alert('Something went wrong, Please try again later')
        $(event.target).attr('disabled', false)

  $('body').on 'click', '.scroll_to', (event)->
    btn = $(event.target)
    to_selector = btn.attr('data-scrollto')
    target = $(to_selector)
    window.targ = target
    if target.size() > 0
      $("html, body").animate({ scrollTop: target.offset().top }, "slow")
    return false

  app.fn.init_user_docs_upload = ()->
    # file upload handler for form.
    $('.user_edit_form_with_docs').fileupload
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

  app.fn.init_user_cover_upload = ()->
    # file upload handler for step 1 form and step 3 form containing image files.
    $('.user_edit_form_with_cover').fileupload
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
