app.views.endorsements = Backbone.View.extend
  initialize: (options)->
    this.type = options.type
    this.template = _.template($('#endorsements_template').html())
    this.collection.on('add', this.render, this)
  render: ()->
    this.$el.html(this.template)
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (endorsement)->
    endorsement_view = new app.views.endorsement({ model: endorsement })
    this.$el.find('#endorsements').prepend( endorsement_view.render().el )
    return this