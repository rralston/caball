app.views.searched_users = Backbone.View.extend
  initialize: (options)->
    this.template = _.template($('#searched_users_template').html())
    # this.collection.on('add', this.render, this)
    # this.collection.on('remove', this.render, this)
    this.collection.on('reset', this.test, this)
    this.project_role_edit_view = options['role_edit_view']

  render: ()->
    this.$el.html(this.template(this.collection.toJSON()))
    this.collection.forEach(this.renderEach, this)
    this.$el.prepend('<a class="close" href="#">&times;</a>')
    return this

  renderEach: (searched_user)->
    searched_user_view = new app.views.searched_user({ model: searched_user, role_edit_view: this.project_role_edit_view })
    this.$el.find('#searched_users_list').prepend( searched_user_view.render().el )
    return this