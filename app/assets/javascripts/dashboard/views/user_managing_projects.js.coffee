app.views.user_managing_projects = Backbone.View.extend
  initialize: ()->
    this.template = _.template($('#user_managing_projects_template').html())
  render: ()->
    this.$el.html(this.template)
    this.collection.forEach(this.renderEach, this)
    return this

  renderEach: (user_project)->
    user_project_view = new app.views.user_project({ model: user_project })
    user_project_all_view = new app.views.user_project({ model: user_project })
    # hide the empty display message 
    this.$el.find('#project-tab-'+user_project.get('status').toLowerCase()).find('.message_for_empty').hide()
    # hide the empty display message for all
    this.$el.find('#project-tab-all').find('.message_for_empty').hide()

    # append it to the particular division
    this.$el.find('#project-tab-'+user_project.get('status').toLowerCase()).append(user_project_view.render().el)
    # append it to the the all division
    this.$el.find('#project-tab-all').append(user_project_all_view.render().el)
