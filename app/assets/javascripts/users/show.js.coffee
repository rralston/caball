# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
#
# CoffeeScript for Users Controller

$(document).ready ->

  app.fn.initialize_send_generic_message()

  $('body').on 'click', '.btn-follow', (event) ->

    if app.fn.check_current_user()
      btn = $(event.target)
      btn.html('Follow')
      console.log 'here'
      url = '/friendships'

      if btn.hasClass('unfollow')
        url = '/friendships/destroy'
        
      $.ajax
        url: url
        type: 'POST'
        data:
          friend_id: btn.attr('data-friend-id')
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
