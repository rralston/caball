app.views.users = Backbone.View.extend
  initialize: (options)->
    this.collection.on('add', this.render, this)

  render: ()->
    this.$el.html('')
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (user)->
    user_view = new app.views.user({ model: user })
    this.$el.append( user_view.render().el )