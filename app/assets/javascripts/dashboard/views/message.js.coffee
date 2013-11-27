app.views.message = Backbone.View.extend
  className: 'message span7'
  initialize: ()->
    this.template = _.template($('#message_template').html())
    console.log this.model

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this
