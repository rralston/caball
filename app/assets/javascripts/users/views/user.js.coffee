app.views.user = Backbone.View.extend
  className: 'user_tile pull-left'
  initialize: ()->
    this.template = _.template($('#user_tile_template').html())

  events: 
    'click .btn-follow-user': 'follow_click'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  follow_click: (event)->
    _this = this
    if app.fn.check_current_user() and app.fn.check_not_same_user(_this.model.id, "You can't follow yourself")
      btn = $(event.target)
      btn.html('Please wait..')

      url = '/friendships'

      if btn.hasClass('unfollow')
        url = '/friendships/destroy'
        
      $.ajax
        url: url
        type: 'POST'
        data:
          friend_id: _this.model.id
        success: (resp)->
          if resp != 'false'
            
            # if it is a follow action add unfollow class
            if btn.hasClass('unfollow')
              btn.html('Follow')
              btn.removeClass('unfollow')

            else
              btn.html('Following')
              btn.addClass('unfollow')
              # set the data-can attr on endorse to false, he can now endorse this user
              
            _this.$el.find('.fans-count').html(resp.followers_count)

          else
            alert('Something went wrong, Please try again.')