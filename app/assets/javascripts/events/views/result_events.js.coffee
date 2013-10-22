app.views.result_events = Backbone.View.extend
  initialize: (options)->
    this.type = options.type
    this.template = _.template($('#result_events_template').html())
    this.collection.on('add', this.renderEach, this)
    this.collection.on('reset', this.render, this)

  events: 
    'click .btn-load_more': 'load_more'

  render: ()->
    this.$el.html( this.template )
    this.collection.forEach(this.renderEach, this)
    this

  renderEach: (result_event)->
    result_event_view = new app.views.result_event({ model: result_event })
    this.$el.find('.event_results').append(result_event_view.render().el)

  load_more: (event)->
    _this = this
    btn = $(event.target)
    btn.html('Please Wait..')
    page_number = btn.attr('data-next-page')
    $.ajax
      url: '/events/load_more'
      type: 'POST'
      data:
        page: page_number
        type: _this.type
        search: app.params_used.search
      success: (resp)->
        if resp != 'false'
          if resp.length > 0
            new_result_event_models = _.map(resp, (event_json)->
              new app.models.result_event(event_json)
            )
            _this.collection.add(new_result_event_models)
            # increment page number on the loadmore button
            $(event.target).attr('data-next-page', ++page_number)
          else
            alert('No more events available')
            $(event.target).hide()
        else
          alert('Something went wrong, Please try again.')
        btn.html('Load More')

