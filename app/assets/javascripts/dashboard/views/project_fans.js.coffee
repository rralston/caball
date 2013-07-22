app.views.project_fans = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#project_fans_template').html())
  render: ()->
    this.$el.html( this.template(this.collection.toJSON()) )
    this.collection.last(8).forEach(this.renderEach, this)
    return this

  renderEach: (fan)->
    fan_view = new app.views.project_fan({ model: fan })
    this.$el.find('#project-fans_list').prepend(fan_view.render().el)