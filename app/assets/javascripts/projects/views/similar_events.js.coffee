app.views.similar_events = Backbone.View.extend
  initialize: (options)->
    this.type = options.type
    this.template = _.template($('#similar_events_template').html())

  render: ()->
    this.$el.html(this.template)
    this.collection.all_events().forEach(this.renderEachAll, this)
    this.collection.current_events().forEach(this.renderEachCurrent, this)
    this.collection.past_events().forEach(this.renderEachPast, this)
    return this

  renderElem: (similar_event)->
    similar_event_view = new app.views.similar_event({ model: similar_event })
    similar_event_view.render()

  renderEachAll: (similar_event) ->
    this.$el.find('#similar-event-tab-all').append( this.renderElem(similar_event).el )
    this.$el.find('#similar-event-tab-all').find('.message_for_empty').remove()
    
  renderEachCurrent: (similar_event) ->
    this.$el.find('#similar-event-tab-current').append( this.renderElem(similar_event).el )
    this.$el.find('#similar-event-tab-current').find('.message_for_empty').remove()

  renderEachPast: (similar_event) ->
    this.$el.find('#similar-event-tab-past').append( this.renderElem(similar_event).el )
    this.$el.find('#similar-event-tab-past').find('.message_for_empty').remove()