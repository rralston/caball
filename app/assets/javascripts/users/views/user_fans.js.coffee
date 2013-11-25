app.views.user_fans = Backbone.View.extend
  initialize: (options)->
    this.template = _.template($('#user_fans_template').html())

    this.count = options.total_fans

    this.collection.on('add', this.render, this)
    this.collection.on('remove', this.render, this)

  render: ()->
    this.$el.html(this.template(this.collection.toJSON()))
    this.collection.last(8).forEach(this.renderEach, this)
    return this

  renderEach: (user_fan)->
    #for n in [1..8]
    user_fan_view = new app.views.user_fan({ model: user_fan })
    this.$el.find('#user_fans_list').prepend( user_fan_view.render().el )
    return this
