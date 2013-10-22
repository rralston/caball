app.views.super_role_tab = Backbone.View.extend
  className: 'super-role-tab tab-pane'
  initialize: ()->
    this.$el.attr('id', 'super-role-tab-'+this.model.get('id'))
    this.template = _.template($('#super_role_tab_template').html())

    this.sub_roles = new app.collections.sub_roles()

    this.sub_roles.reset(JSON.parse(this.model.get('subroles_json')))
  
  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))

    this.render_sub_role_filters()
    this.render_sub_role_tabs()

    return this

  render_sub_role_filters: ()->
    sub_roles_filters_view = new app.views.sub_role_filters({ collection: this.sub_roles })
    this.$el.find('.sub_roles_filters').html(sub_roles_filters_view.render().el)

  render_sub_role_tabs: ()->
    sub_roles_tabs_view = new app.views.sub_role_tabs({ collection: this.sub_roles })
    this.$el.find('.sub_roles_tabs').html(sub_roles_tabs_view.render().el)