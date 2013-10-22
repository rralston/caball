app.views.sub_role_filters = Backbone.View.extend
  tagName: 'ul'
  className: 'clearfix custom-green-filters nav'
  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (sub_role)->
    sub_role_filter_view = new app.views.sub_role_filter({ model: sub_role })
    this.$el.append( sub_role_filter_view.render().el )