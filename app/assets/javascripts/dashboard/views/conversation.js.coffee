app.views.conversation = Backbone.View.extend
  className: 'conversation'
  initialize: ()->
    this.template = _.template($('#conversation_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this

    