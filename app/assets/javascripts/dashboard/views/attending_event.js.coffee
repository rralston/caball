app.views.attending_event = Backbone.View.extend
  className: 'event'
  initialize: ()->
    this.template = _.template($('#attending_event_template').html())
    this.model.on('remove_this', this.remove_item, this)

  events: 
    'click .btn-unattend': 'unattend'


  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this

  unattend: ()->
    _this = this
    $.ajax
      url: '/events/unattend'
      type: 'POST'
      data:
        id: _this.model.get('id')
      success: (resp)->
        if resp != false
          _this.model.trigger('remove_this')
        else
          alert('Something went wrong, Please try again later')

  remove_item: ()->
    this.remove()