window.app = window.app || {models: {}, collections: {}, views: {}, fn: {}, routers: {}, events: {}, constants: {}, faye: {}}

_.extend(app.events, Backbone.Events)


app.fn.show_loader_in_div = function(elem){
  // pass a jquery element
  elem.html('Please wait.. <img src="/assets/ajax-loader.gif"/>')
}

app.fn.resize_form = function(){
  var current = $('#steps').data('index');
  var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
  $('#steps').height(stepHeight);
}

app.fn.initialize_datetime_picker = function(selector){
  $( selector ).datetimepicker({
    format: 'yyyy-mm-dd hh:ii',
    autoclose: true,
    todayBtn: true,
    startDate: new Date(),
  });
}

  