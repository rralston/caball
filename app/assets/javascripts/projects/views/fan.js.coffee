app.views.fan = Backbone.View.extend
  className: 'fan pull-left'
  initialize: ()->
    this.template = _.template($('#user_fan_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this