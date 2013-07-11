app.views.recommended_people = Backbone.View.extend
  tagName: 'ul'
  className: 'recommended_people'
  
  initialize: ()->
    app.events.on('next_recommended_people', this.next_recommended_people)
    this.collection.on('add', this.renderEach, this)

  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (person_object)->
    person_view = new app.views.recommended_person({ model: person_object })
    this.$el.append(person_view.render().el)

  next_recommended_people: (event)->
    _this = this
    page_number = parseInt($(event.target).attr('data-next'))
    $.ajax
      url: 'users/recommended_people'
      data: 
        page_number: page_number
      success: (resp)->
        # if type is object it will contain new projects to load.
        if resp.length > 0
          new_recommended_people_models = _.map(resp, (person_json)->
            new app.models.recommended_person(person_json)
          )
          app.recommended_people.add(new_recommended_people_models)
          # increment page number on the loadmore button
          $(event.target).attr('data-next', ++page_number)
        else
          alert('No more recommendations available')
          $(event.target).hide()