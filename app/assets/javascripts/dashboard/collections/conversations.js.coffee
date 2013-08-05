app.collections.conversations = Backbone.Collection.extend
  model: app.models.conversation
  set_values: ()->
    this.unread_count = _.reduce(this.models, (memo, model)->
      return memo + parseInt(model.get('unread_count'))
    , 0)

    this.messages_count = _.reduce(this.models, (memo, model) ->
      return memo + parseInt(model.get('count_messages'))
    , 0)

