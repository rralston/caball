app.views.activity = Backbone.View.extend
  className: 'item well'
  initialize: ()->
    this.blog_activity_template = _.template($('#blog_activity_template').html())
    this.project_activity_template = _.template($('#project_activity_template').html())
    this.comment_activity_template = _.template($('#comment_activity_template').html())

  render: ()->
    trackable_type = this.model.get('trackable_type').toLowerCase()
    # render the template based on the trackable type
    this.$el.html this[trackable_type + '_activity_template'] this.model.toJSON()

    return this
