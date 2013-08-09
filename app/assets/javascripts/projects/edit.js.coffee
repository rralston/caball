$(document).ready ()->

  $('body').on 'change', "#project_union" , (event)->
    val = $(event.target).val()
    if val == 'WGA'
      $('#wga_terms').show()
    else 
      $('#wga_terms').hide()