app.views.attendees = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#attendees_template').html())

  render: ()->
    this.$el.html( this.template(this.collection.toJSON()) )
    this.collection.forEach(this.renderEach, this)
    this

  renderEach: (attendee)->
    attendee = new app.views.attendee({ model: attendee })
    this.$el.find('#attendees_list').prepend(attendee.render().el)