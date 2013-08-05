app.views.similar_project = Backbone.View.extend
  className: 'project pull-left'
  initialize: ()->
    this.template = _.template($('#similar_project_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this