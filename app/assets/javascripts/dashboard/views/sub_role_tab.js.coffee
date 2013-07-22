app.views.sub_role_tab = Backbone.View.extend
  className: 'sub-role-tab tab-pane'
  initialize: ()->
    this.$el.attr('id', 'sub-role-tab-'+this.model.get('id'))
    this.template = _.template($('#sub_role_tab_template').html())

    this.role_applications = new app.collections.role_applications()
    
    this.role_applications.reset(this.model.get('applications'))

  
  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))

    this.render_role_applications()

    return this

  render_role_applications: ()->
    role_applications_view = new app.views.role_applications({ collection: this.role_applications })
    this.$el.find('.sub_role_applicatons').html(role_applications_view.render().el)