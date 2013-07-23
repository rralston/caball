app.views.user_event = Backbone.View.extend
  className: 'event'
  initialize: ()->
    this.template = _.template($('#user_event_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this

    