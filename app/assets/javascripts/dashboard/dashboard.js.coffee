$(document).ready ->
  $('#isotope_container').isotope
    itemSelector: '.item'
    animationOptions:
      duration: 750
      easing: 'linear'
      queue: false

  $('.load_more').on 'click', (event)->
    type = $(event.target).attr('data-type')
    app.events.trigger(type, event)