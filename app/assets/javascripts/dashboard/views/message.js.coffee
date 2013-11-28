app.views.message = Backbone.View.extend
  className: 'message span7'
  initialize: (options)->
    this.template              = _.template($('#message_template').html())
    
    this.is_application_denial = options['is_application_denial']
    this.is_originator         = options['is_originator']
    

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this
