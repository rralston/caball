app.views.recommended_projects = Backbone.View.extend
  tagName: 'ul'
  className: 'recommended_projects'
  initialize: ()->
    app.events.on('next_recommended_projects', this.next_projects)
    this.collection.on('add', this.renderEach, this)

  render: ()->
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (project_object)->
    project_view = new app.views.recommended_project({ model: project_object })
    this.$el.append(project_view.render().el)

  next_projects: (event)->
    page_number = parseInt($(event.target).attr('data-next'))
    $.ajax
      url: 'users/recommended_projects'
      data: 
        page_number: page_number
      success: (resp)->
        # if type is object it will contain new projects to load.
        if resp.length > 0
          new_recommended_project_models = _.map(resp, (project_json)->
            new app.models.recommended_project(project_json)
          )
          app.recommended_projects.add(new_recommended_project_models)
          # increment page number on the loadmore button
          $(event.target).attr('data-next', ++page_number)
        else
          alert('No more recommendations available')
          $(event.target).hide()