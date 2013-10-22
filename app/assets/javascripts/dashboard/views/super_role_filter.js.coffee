app.views.super_role_filter = Backbone.View.extend
  tagName: 'li'
  className: 'pull-left super-role-filter'
  initialize: ()->
    this.template = _.template($('#super_role_filter_template').html())
  
  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))
    return this