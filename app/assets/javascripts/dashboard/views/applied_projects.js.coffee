app.views.applied_projects = Backbone.View.extend
  render: ()->
    this.$el.html('')
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (applied_project)->
    applied_project_view = new app.views.applied_project({ model: applied_project })
    this.$el.append(applied_project_view.render().el)