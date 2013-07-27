app.views.endorsement = Backbone.View.extend
  className: 'endorsement pull-left'
  initialize: ()->
    this.template = _.template($('#endorsement_template').html())

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this