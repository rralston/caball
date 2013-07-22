app.views.super_role_tab = Backbone.View.extend
  className: 'super-role-tab tab-pane'
  initialize: ()->
    this.$el.attr('id', 'super-role-tab-'+this.model.get('id'))
    this.template = _.template($('#super_role_tab_template').html())

    this.sub_roles = new app.collections.sub_roles()
    this.sub_roles.reset(this.model.get('subroles_json'))
  
  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))

    this.render_sub_role_filters()

    return this

  render_sub_role_filters: ()->
    sub_roles_filters_view = new app.views.sub_role_filters_view({ collection: this.sub_roles })
    this.$el.find('.sub_roles_filters').html(sub_roles_filters_view.render().el)