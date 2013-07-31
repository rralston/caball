app.views.recommended_project = Backbone.View.extend
  className: 'project recommended_project pull-left'
  tagName: 'li'
  initialize: ()->
    this.recommended_project_template = _.template($('#recommended_project_template').html())
  
  render: ()->
    this.$el.html this.recommended_project_template this.model.toJSON()
    return this
