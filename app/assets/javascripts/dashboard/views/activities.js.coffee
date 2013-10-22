app.views.activities = Backbone.View.extend
  initialize: ()->
    $(this.el).addClass('activities_container')
    app.events.on('next_activities_feed', this.next_activities_feed)
    this.collection.on('add', this.renderEach, this)
  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (activity_item)->
    # if case is to skip the case where the trackable object is later destroyed from the database.
    if activity_item.get('trackable') != null
      this.$el.append(this.activityDivRender(activity_item).el)

  new_items_div: (activity_models) ->
    _this = this
    _.map(activity_models, (activity_model)->
      _this.activityDivRender(activity_model).$el
    )

  activityDivRender: (activity_item)->
    activity_view = new app.views.activity({ model: activity_item })
    activity_view.render()

  next_activities_feed: (event)->
    _this = this
    button = $(event.target)
    page_number = parseInt(button.attr('data-next'))
    $.ajax
      url: '/activities/load_more'
      data: 
        page_number: page_number
      success: (resp)->
        if resp.length > 0
          activity_models = _.map(resp, (json_activity)->
            new app.models.activity(json_activity)
          )

          # console.log _this

          app.activities.add(activity_models)


          # add each activity item div to the isotope one by one
          # _.each(app.activities_view.new_items_div(activity_models), (activity_div)->
          #   $('#isotope_container').isotope('insert', activity_div)
          # _this.$el.append(app.activities_view.new_items_div(activity_models))
          # )
          # increment the page number for the load more button
          button.attr('data-next', ++page_number)
        else
          alert('No more feed is available')
          button.hide()            
