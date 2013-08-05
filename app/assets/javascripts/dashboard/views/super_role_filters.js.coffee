app.views.super_role_filters = Backbone.View.extend
  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (super_role)->
    super_role_filter_view = new app.views.super_role_filter({ model: super_role })
    this.$el.append( super_role_filter_view.render().el )