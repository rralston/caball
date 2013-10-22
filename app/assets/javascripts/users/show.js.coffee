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
        alert('You need to follow the user in order to endorse him')
      else
        $('#endorsement_modal').modal('show')

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