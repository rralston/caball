app.views.project_role = Backbone.View.extend
  className: 'project_role'
  initialize: ()->
    this.template = _.template($('#project_role_template').html())
    this.model.on('set', this.render, this)
    app.events.on('role_updated_'+this.model.get('id'), this.render, this)
  events: 
    'click .edit_role': 'edit_role'
    'click .delete_role': 'delete_role'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    this

  edit_role: (event)->
    app.project_role_edit_view.edit_this(this.model)
    false
  delete_role: (event)->
    _this = this
    $.ajax
      url: '/roles/destroy'
      type: 'POST'
      data:
        id: _this.model.get('id')
      success: (resp) ->
        if resp == true
          app.project_roles.remove(_this.model)
        else
          alert('Something went wrong. Please try again later.')

    false

