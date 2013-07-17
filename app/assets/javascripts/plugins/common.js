window.app = window.app || {models: {}, collections: {}, views: {}, fn: {}, routers: {}, events: {}, constants: {}, faye: {}}

_.extend(app.events, Backbone.Events)

app.constants.enter_key_code = 13;
app.constants.esc_key_code = 27

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

app.fn.initalize_location_click_handler = function(click_selector, input_selector){
  
  $(click_selector).click(function(){ 
    (function() {
      var getPosition = function (options) {
        var deferred = $.Deferred();

        navigator.geolocation.getCurrentPosition(
          deferred.resolve,
          deferred.reject,
          options);

        return deferred.promise();
      };

      var lookupCountry = function (position) {
        var deferred = $.Deferred();

        var latlng = new google.maps.LatLng(
                            position.coords.latitude,
                            position.coords.longitude);
        var geoCoder = new google.maps.Geocoder();
        geoCoder.geocode({ location: latlng }, deferred.resolve);

        return deferred.promise();
      };

      var displayResults = function (results, status) {            
        $(input_selector).val(results[3].formatted_address);  
        var $loca = results[3].formatted_address;
        alert($loca);
          // $("body").append("<div>").text(results[3].formatted_address);      
      };
    
    $(function () {
        $.when(getPosition())
         .pipe(lookupCountry)
         .then(displayResults);
     });

    }());
  });  
}


  

  