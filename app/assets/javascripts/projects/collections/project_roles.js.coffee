app.collections.project_roles = Backbone.Collection.extend
  model: app.models.project_role

  filled_roles: ()->
    filled_roles = _.filter(this.models, (role) ->
      return role.get('filled') == true
    )
    filled_roles

  unfilled_roles: ()->
    unfilled_roles = _.filter(this.models, (role) ->
      return role.get('filled') == false
    )
    unfilled_roles