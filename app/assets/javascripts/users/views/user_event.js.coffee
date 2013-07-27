app.views.user_event = Backbone.View.extend
  className: 'event pull-left'
  initialize: ()->
    this.template = _.template($('#user_event_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this