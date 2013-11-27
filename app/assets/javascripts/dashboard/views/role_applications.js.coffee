app.views.role_applications = Backbone.View.extend
  render: ()->
    this.collection.sorted().forEach(this.renderEach, this)
    return this

  renderEach: (role_application)->
    role_application_view = new app.views.role_application({ model: role_application })
    this.$el.append( role_application_view.render().el )