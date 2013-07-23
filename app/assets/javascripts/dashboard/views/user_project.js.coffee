app.views.user_project = Backbone.View.extend
  className: 'project'
  initialize: ()->
    this.template = _.template($('#user_project_template').html())

  events:
    'click .btn-manage': 'show_project'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this

  show_project:()->
    console.log 'here'
    manage_project_view = new app.views.manage_project({ model: this.model })
    $('#dashboard_projects').html(manage_project_view.render().el)

    