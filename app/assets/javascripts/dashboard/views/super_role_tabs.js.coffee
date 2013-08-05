app.views.super_role_tabs = Backbone.View.extend
  className: 'tab-content'
  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (super_role)->
    super_role_tab_view = new app.views.super_role_tab({ model: super_role })
    this.$el.append( super_role_tab_view.render().el )