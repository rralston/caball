app.views.conversations = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#conversations_template').html())
  render: ()->
    this.$el.html( this.template(this.collection.toJSON()) )
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (conversation)->
    conversation_view = new app.views.project_conversation({ model: conversation })
    this.$el.find('#conversations_list').prepend(conversation_view.render().el)