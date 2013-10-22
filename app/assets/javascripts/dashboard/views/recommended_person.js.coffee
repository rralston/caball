app.views.recommended_person = Backbone.View.extend
  className: 'recommended_person'
  tagName: 'li'
  initialize: ()->
    this.recommended_person_template = _.template($('#recommended_person_template').html())

  events: 
    'click .btn-follow-user': 'follow_click'

  render: ()->
    this.$el.html this.recommended_person_template this.model.toJSON()
    return this

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

          else
            alert('Something went wrong, Please try again.')
