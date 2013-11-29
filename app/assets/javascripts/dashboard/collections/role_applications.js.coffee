app.collections.role_applications = Backbone.Collection.extend
  model: app.models.role_application

  sorted: () -> 
    result = _.sortBy( this.models, (application) ->
      return application.get('approved') == false
    )

    result
