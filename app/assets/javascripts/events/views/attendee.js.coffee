app.views.attendee = Backbone.View.extend
  className: 'attender-img pull-left'
  initialize: ()->
    this.template = _.template($('#attendee_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this