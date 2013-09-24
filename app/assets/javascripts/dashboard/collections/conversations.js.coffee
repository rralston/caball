app.collections.conversations = Backbone.Collection.extend
  model: app.models.conversation
  set_values: ()->
    this.unread_count = _.reduce(this.models, (memo, model)->
      return memo + parseInt(model.get('unread_count'))
    , 0)

    this.messages_count = _.reduce(this.models, (memo, model) ->
      return memo + parseInt(model.get('count_messages'))
    , 0)

  time_sorted: ()->
    sorted = _.sortBy(this.models, (conversation_model)->
      return conversation_model.get('last_message').created_at
    )
    return sorted


