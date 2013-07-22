app.views.applied_project = Backbone.View.extend
  className: 'project'
  initialize: ()->
    this.template = _.template($('#applied_project_template').html())
  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this
    