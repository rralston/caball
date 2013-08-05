app.views.role_application = Backbone.View.extend
  className: 'pull-left role_application'
  initialize: ()->
    this.template = _.template($('#role_application_template').html())
  
  events:
    'click .action.accept': 'approve'
    'click .action.reject': 'cancel_action'
    'click .btn-view-cover': 'show_cover'

  render: ()->
    this.$el.html(this.template( this.model.toJSON() ))
    return this

  show_cover: (event)->
    event.stopPropagation()
    modal = $('#view_cover')
    modal.find('.cover-header').html('Cover - '+this.model.get('user').name)
    modal.find('#cover-message').html(this.model.get('message'))
    modal.modal('show')

  approve: (event)->
    _this = this
    btn = $(event.target)
    btn.addClass('loading-icon').removeClass('accept')
    $.ajax
      url: '/role_applications/approve'
      data:
        application_id: _this.model.get('id')
      type: 'POST'
      success: (resp)->
        btn.removeClass('loading-icon').addClass('accept')
        if resp != 'false'
          alert 'Applicant added to the role'
          _this.model.set('approved', true)
          _this.render()
        else
          alert 'Error approving application. May be you approved a appilcation for this role already. Please check'    

  cancel_action: (event)->
    # if the application is already approved, then un approve, if not reject application
    if this.model.get('approved') == true
      this.un_approve(event)
    else  
      this.reject_application

  un_approve: (event)->
    _this = this
    btn = $(event.target)
    btn.addClass('loading-icon').removeClass('reject')
    $.ajax
      url: '/role_applications/un_approve'
      data:
        application_id: _this.model.get('id')
      type: 'POST'
      success: (resp)->
        btn.removeClass('loading-icon').addClass('reject')
        if resp != 'false'
          alert 'Applicant un approved to the role'
          _this.model.set('approved', false)
          _this.render()
        else
          alert 'Error processing application. Please try later'
