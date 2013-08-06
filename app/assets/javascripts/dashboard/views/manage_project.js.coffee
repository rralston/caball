app.views.manage_project = Backbone.View.extend
  className: 'manage_project'
  initialize: ()->
    this.template = _.template($('#manage_project_template').html())

    # create cuper role collections
    this.super_roles_collection = new app.collections.super_roles()
    this.super_roles_collection.reset(this.model.get('roles_for_dashboard'))

  events: 
    'click .mark_done': 'mark_as_done'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    
    project_fans = new app.collections.project_fans()
    project_fans.reset(this.model.get('fans'))

    project_fans_view = new app.views.project_fans({ collection: project_fans })

    this.$el.find('#project-fans').html( project_fans_view.render().el )

    

    this.render_super_role_circles()
    this.render_super_role_filters()
    this.render_super_role_tabs()

    return this

  render_super_role_circles: ()->
    super_role_circles_view = new app.views.super_role_circles({ collection: this.super_roles_collection })
    this.$el.find('#project-roles-circles').html( super_role_circles_view.render().el )

  render_super_role_filters: ()->
    super_role_filters_view = new app.views.super_role_filters({ collection: this.super_roles_collection })
    this.$el.find('#project-roles-filters').html( super_role_filters_view.render().el )

  render_super_role_tabs: ()->
    super_role_tabs_view = new app.views.super_role_tabs({ collection: this.super_roles_collection })
    this.$el.find('#project-roles-tabs').html( super_role_tabs_view.render().el )

  mark_as_done: (event)->
    _this = this
    $(event.target).html('Please wait..')
    this.model.save {
      status: 'Completed'
    }, {
      success: (model, response) ->
        console.log response
        if response
            _this.model.set('status', 'Completed')
            alert('Project marked as Done')
            _this.render()
    }
