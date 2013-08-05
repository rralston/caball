app.views.recommended_person = Backbone.View.extend
  className: 'recommended_person'
  tagName: 'li'
  initialize: ()->
    this.recommended_person_template = _.template($('#recommended_person_template').html())
  
  render: ()->
    this.$el.html this.recommended_person_template this.model.toJSON()
    return this
