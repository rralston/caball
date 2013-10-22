app.views.message = Backbone.View.extend
  className: 'message span7'
  initialize: ()->
    this.template = _.template($('#message_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this
