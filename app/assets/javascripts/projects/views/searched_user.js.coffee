app.views.searched_user = Backbone.View.extend
  className: 'searched_user'
  initialize: (options)->
    this.template = _.template($('#searched_user_template').html())
    this.project_role_edit_view = options['role_edit_view']

  events: 
    'click .follow_user': 'follow_user'
    'click .select_user': 'select_user'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this.delegateEvents()
    this

  follow_user: (event)->
    btn = $(event.target)
    btn.html('wait..')
    _this = this 
    $.ajax
      url: '/friendships'
      type: 'POST'
      data:
        friend_id: _this.model.get('id')
      success: (resp) ->
        if resp != false
          _this.model.set('user_following', true)
          _this.render()
        else
          alert('Something went wrong. Please try again later')
          btn.html('follow')

  select_user: (event) ->
    _this = this
    this.project_role_edit_view.add_user_to_role(this.model.toJSON())
    true
