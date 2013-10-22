app.views.user_project = Backbone.View.extend
  className: 'project'
  initialize: ()->
    this.template = _.template($('#user_project_template').html())

  events:
    'click .btn-manage.active': 'show_project'

  render: ()->
    this.$el.html( this.template(this.model.toJSON()) )
    return this

  show_project:(event)->
    
    btn = $(event.target)
    btn.html('Please wait...')
    btn.removeClass('active')

    _this = this
    $.ajax
      url: '/dashboard/manage_project'
      data:
        id: _this.model.id
      success: (resp)->
        # set the extra attributes returned by the server
        _this.model.set(resp)
        
        manage_project_view = new app.views.manage_project({ model: _this.model })
        $('#dashboard_projects').html(manage_project_view.render().el)
        $("html, body").animate({ scrollTop: 0 }, "slow")

        btn.html('Please wait...')
        btn.addClass('active')

    