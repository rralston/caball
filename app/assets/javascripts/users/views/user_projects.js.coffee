app.views.user_projects = Backbone.View.extend
  initialize: (options)->
    this.type = options.type
    this.template = _.template($('#similar_projects_template').html())

  render: ()->
    this.$el.html(this.template)
    this.collection.all_projects().forEach(this.renderEachAll, this)
    this.collection.current_projects().forEach(this.renderEachCurrent, this)
    this.collection.past_projects().forEach(this.renderEachPast, this)
    return this

  renderElem: (user_project)->
    user_project_view = new app.views.user_project({ model: user_project })
    user_project_view.render()

  renderEachAll: (user_project) ->
    this.$el.find('#user-project-tab-all .message_for_empty').hide()
    this.$el.find('#user-project-tab-all').append( this.renderElem(user_project).el )

  renderEachCurrent: (user_project) ->
    this.$el.find('#user-project-tab-current .message_for_empty').hide()
    this.$el.find('#user-project-tab-current').append( this.renderElem(user_project).el )

  renderEachPast: (user_project) ->
    this.$el.find('#user-project-tab-past .message_for_empty').hide()
    this.$el.find('#user-project-tab-past').append( this.renderElem(user_project).el )