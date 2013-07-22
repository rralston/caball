app.views.role_application = Backbone.View.extend
  className: 'pull-left role_application'
  initialize: ()->
    this.template = _.template($('#role_application_template').html())
  
  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))
    return this