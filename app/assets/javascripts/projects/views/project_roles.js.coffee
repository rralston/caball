app.views.project_roles = Backbone.View.extend
  initialize: (options)->
    this.template = _.template($('#project_roles_template').html())
    this.collection.on('add', this.render_added_roles, this)
    this.collection.on('remove', this.render_added_roles, this)

  render: ()->
    this.$el.html(this.template(this.collection.toJSON()))
    this.collection.forEach(this.renderEach, this)
    return this

  render_added_roles: ()->
    this.$el.find('#project_roles_display_region').html('')
    this.collection.forEach(this.renderEach, this)
    return this    

  renderEach: (project_role)->
    project_role_view = new app.views.project_role({ model: project_role })
    this.$el.find('#project_roles_display_region').prepend( project_role_view.render().el )
    return this