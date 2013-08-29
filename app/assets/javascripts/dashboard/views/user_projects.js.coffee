app.views.user_projects = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#user_projects_template').html())
  render: ()->
    this.$el.html(this.template)
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (user_project)->
    user_project_view = new app.views.user_project({ model: user_project })
    # hide the empty display message 
    this.$el.find('#project-tab-'+user_project.get('status').toLowerCase()).find('.message_for_empty').hide()
    # append it to the particular division
    this.$el.find('#project-tab-'+user_project.get('status').toLowerCase()).append(user_project_view.render().el)

