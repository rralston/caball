app.views.comment = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#comment_template').html())
  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this