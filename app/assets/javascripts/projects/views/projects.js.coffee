app.views.projects = Backbone.View.extend
  initialize: ()->
    this.collection.on('add', this.renderEach, this)

  render: ()->
    this.$el.html('')
    this.collection.forEach(this.renderEach, this)
    this

  renderEach: (project)->
    project_view = new app.views.project({ model: project })
    this.$el.append(project_view.render().el)