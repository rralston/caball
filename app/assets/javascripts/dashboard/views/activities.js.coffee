app.views.activities = Backbone.View.extend
  initialize: ()->
    $(this.el).attr('id', 'isotope_container')
    # this.collection.on('add', this.renderNewItem, this)
  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (activity_item)->
    this.$el.append(this.activityDivRender(activity_item).el)

  new_items_div: (activity_models) ->
    _this = this
    _.map(activity_models, (activity_model)->
      _this.activityDivRender(activity_model).$el
    )

  activityDivRender: (activity_item)->
    activity_view = new app.views.activity({ model: activity_item })
    activity_view.render()
