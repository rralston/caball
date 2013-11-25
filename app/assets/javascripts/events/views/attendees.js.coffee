app.views.attendees = Backbone.View.extend
  initialize: (options)->
    this.template = _.template($('#attendees_template').html())
    this.total_attendees = options.total_attendees
    this.collection.on('add', this.render, this)
    this.collection.on('remove', this.render, this)

  render: ()->
    this.$el.html( this.template(this.collection.toJSON()) )
    this.collection.last(8).forEach(this.renderEach, this)
    this

  renderEach: (attendee)->
    attendee = new app.views.attendee({ model: attendee })
    this.$el.find('#attendees_list').prepend(attendee.render().el)