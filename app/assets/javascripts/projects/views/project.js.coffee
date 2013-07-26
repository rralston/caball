app.views.project = Backbone.View.extend
  className: 'project'
  initialize: ()->
    this.template = _.template($('#project_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this