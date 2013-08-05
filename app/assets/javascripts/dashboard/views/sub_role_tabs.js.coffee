app.views.sub_role_tabs = Backbone.View.extend
  className: 'tab-content'
  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (sub_role)->
    sub_role_tab_view = new app.views.sub_role_tab({ model: sub_role })
    this.$el.append( sub_role_tab_view.render().el )