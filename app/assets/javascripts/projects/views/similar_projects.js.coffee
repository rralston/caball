app.views.similar_projects = Backbone.View.extend
  initialize: (options)->
    this.type = options.type
    this.template = _.template($('#similar_projects_template').html())

  render: ()->
    this.$el.html(this.template)
    this.collection.all_projects().forEach(this.renderEachAll, this)
    this.collection.current_projects().forEach(this.renderEachCurrent, this)
    this.collection.past_projects().forEach(this.renderEachPast, this)
    return this

  renderElem: (project)->
    similar_project_view = new app.views.similar_project({ model: project })
    similar_project_view.render()

  renderEachAll: (project) ->
    this.$el.find('#user-project-tab-all').append( this.renderElem(project).el )
    this.$el.find('#user-project-tab-all').find('.message_for_empty').remove()

  renderEachCurrent: (project) ->
    this.$el.find('#user-project-tab-current').append( this.renderElem(project).el )
    this.$el.find('#user-project-tab-current').find('.message_for_empty').remove()

  renderEachPast: (project) ->
    this.$el.find('#user-project-tab-past').append( this.renderElem(project).el )
    this.$el.find('#user-project-tab-past').find('.message_for_empty').remove()