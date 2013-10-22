app.views.project_fan = Backbone.View.extend
  className: 'fan-img pull-left'
  initialize: ()->
    this.template = _.template($('#project_fan_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this