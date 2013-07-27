# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
#
# CoffeeScript for Users Controller

$(document).ready ->
  
  $('body').on 'click', '.send-generic-message', (event)->
    app.fn.show_generic_message_modal(event)