app.collections.user_projects = Backbone.Collection.extend
  model: app.models.user_project

  past_projects: ()->
    # past_project = _.filter(this.models, (project_object) -> 
    #   return Date.parse(project_object.get('start').date_time) < Date.parse(Date())
    # )
    # past_project
    this.models

  current_projects: ()->
    # upcoming_project = _.filter(this.models, (project_object) ->
    #   return Date.parse(project_object.get('start').date_time) > Date.parse(Date())
    # )
    
    # _.sortBy( upcoming_project, (project_object) ->
    #   return Date.parse(project_object.get('start').date_time)
    # )
    this.models

  all_projects: ()->
    this.models