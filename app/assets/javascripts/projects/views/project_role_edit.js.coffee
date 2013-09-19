app.views.project_role_edit = Backbone.View.extend
  className: 'project_role_edit'
  initialize: ()->
    this.template = _.template($('#project_role_edit_template').html())
    this.searched_users_collection = new app.collections.searched_users()
    this.searched_users_view = new app.views.searched_users({collection: this.searched_users_collection, role_edit_view: this})
    console.log('initializing edit view')

  events: 
    'keypress #search_users': 'search_users'
    'submit #project_role_form': 'add_role'
    'click .close': 'close_users_result'
    # 'change select': 'update_after_select'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    app.fn.adjust_slider_height()
    this

  search_users: (event) ->
    _this = this
    input_div = $('#search_users')
    input = input_div.val()
    if input.length >= 3
      $.ajax
        url: '/users/search_by_name'
        data:
          query: input
        success: (users)->

          if _.size(users) > 0
            _this.searched_users_collection.reset(users)
            # destroy the old collection view and create new once.
            _this.searched_users_view.remove()
            
            _this.searched_users_view = new app.views.searched_users({collection: _this.searched_users_collection, role_edit_view: _this})
            _this.$el.find('#searched_users_for_role').html(_this.searched_users_view.render().el)

            _this.$el.find('#searched_users_for_role').show()
          else
            _this.$el.find('#searched_users_for_role').html('No users found.')
            _this.$el.find('#searched_users_for_role').prepend('<a class="close" href="#">&times;</a>')      
            _this.$el.find('#searched_users_for_role').show()
    else
      _this.$el.find('#searched_users_for_role').html('')
      _this.$el.find('#searched_users_for_role').hide()

  add_user_to_role: (user_data)->
    this.model.set('approved_user', user_data)
    this.$el.find('#search_users').val(user_data.name)
    this.$el.find('#searched_users_for_role').hide()
    this.render()
    app.fn.adjust_slider_height()

  add_role: (event)->
    _this = this
    select = this.$el.find('.super_role_select')
    if select.val() == '---'
      alert('Select Role')
    else
      data = $('#project_role_form').serialize()
      $.ajax
        url: '/projects/add_filled_role'
        type: "POST"
        data: data
        success: (resp) ->
          if typeof _this.model.get('id') == 'undefined'
            # if there is no id, it says that this is a new role being added.
            _this.model.set(resp)
            # add it to the collection so that it will get rendered on the right hand side
            app.project_roles.add(_this.model)
          else
            # if id is present, this is a old role being edited.
            # so call the event of roles display to refresh this role's html.
            _this.model.set(resp)
            app.events.trigger('role_updated_'+_this.model.get('id'))


          # create it self a new model and render the edit view so that the form will be refreshed
          _this.model = new app.models.project_role()
          _this.render()

          $("html, body").animate({ scrollTop: 0 }, "slow");

    false

  edit_this: (role_model)->
    this.model = role_model
    this.render()
    app.fn.adjust_slider_height()

    $("html, body").animate({ scrollTop: 0 }, "slow");

  close_users_result: (event)->
    this.$el.find('#searched_users_for_role').hide()
    this.$el.find('#search_users').val('')
    false


