app.views.project_roles = Backbone.View.extend
  initialize: (options)->
    this.template = _.template($('#project_roles_template').html())
    this.collection.on('add', this.render_added_roles, this)
    this.collection.on('remove', this.render_added_roles, this)

  render: ()->
    this.$el.html(this.template(this.collection.toJSON()))
    this.collection.filled_roles().forEach(this.renderFilled, this)
    this.collection.unfilled_roles().forEach(this.renderUnFilled, this)
    return this

  render_added_roles: ()->
    this.$el.find('#filled_roles').html('')
    this.$el.find('#unfilled_roles').html('')
    this.collection.filled_roles().forEach(this.renderFilled, this)
    this.collection.unfilled_roles().forEach(this.renderUnFilled, this)
    app.fn.adjust_slider_height()
    return this    


  renderFilled: (project_role)->
    this.$el.find('#filled_roles .empty_message').hide()
    project_role_view = new app.views.project_role({ model: project_role })
    this.$el.find('#filled_roles').prepend( project_role_view.render().el )
    return this

  renderUnFilled: (project_role)->
    this.$el.find('#unfilled_roles .empty_message').hide()
    project_role_view = new app.views.project_role({ model: project_role })
    this.$el.find('#unfilled_roles').prepend( project_role_view.render().el )
    return this