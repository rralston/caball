app.views.super_role_circles = Backbone.View.extend
  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (super_role)->
    super_role_circle_view = new app.views.super_role_circle({ model: super_role })
    this.$el.append( super_role_circle_view.render().el )