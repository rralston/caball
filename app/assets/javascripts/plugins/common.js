window.app = window.app || {models: {}, collections: {}, views: {}, fn: {}, routers: {}, events: {}, constants: {}, faye: {}}

_.extend(app.events, Backbone.Events)


app.fn.show_loader_in_div = function(elem){
  // pass a jquery element
  elem.html('Please wait.. <img src="/assets/ajax-loader.gif"/>')
}