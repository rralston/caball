app.views.sub_role_filter = Backbone.View.extend
  tagName: 'li'
  className: 'pull-left sub-role-filter'
  initialize: ()->
    this.template = _.template($('#sub_role_filter_template').html())
  
  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))
    return this