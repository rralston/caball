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

app.fn.bind_report_event = function(){
  $('body').on('click', '.report-btn',  function(event){
    btn = $(event.target)
    btn.attr('disabled', 'disabled')
    $.ajax({
      url: '/report',
      type: 'POST',
      data: {
        entity: btn.attr('data-entity'),
        id: btn.attr('data-id')
      },
      success: function(resp){
        if(resp == 'true'){
         alert('Feedback noted. Thank You for helping us') 
         btn.attr('disabled', false)
         $('#report-modal').modal('hide')
        }
      }
    })
  });
}
  

  