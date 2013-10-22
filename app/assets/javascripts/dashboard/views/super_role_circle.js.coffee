app.views.super_role_circle = Backbone.View.extend
  className: 'pull-left super-role-circle'
  initialize: ()->
    this.template = _.template($('#super_role_circle_template').html())

  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))
    return this