app.collections.similar_projects = Backbone.Collection.extend
  model: app.models.similar_project

  past_projects: ()->
    past_project = _.filter(this.models, (project_object) -> 
      return project_object.get('status') == 'Completed'
    )
    past_project

  current_projects: ()->
    upcoming_project = _.filter(this.models, (project_object) ->
      return project_object.get('status') != 'Completed'
    )
    upcoming_project

  all_projects: ()->
    this.models