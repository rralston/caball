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

app.fn.check_if_current_user_included = function(user_ids){
  found_user = _.find(user_ids, function(user_id){
    return user_id == app.current_user.id
  })
  return (typeof found_user != "undefined")
}

app.fn.bind_click_event_on_modal_btn = function(selector){
  
  $('body').on('click', selector +' .btn-send-message-generic', function(event){
    var modal = $('#send_message_generic_modal')
    var subject = modal.find('#message_subject').val()
    var body = modal.find('#message_body').val()
    var recipients = modal.find('#message_recipients').val()
    var btn = modal.find('.btn-send-message-generic')
    
    if (subject == '' || body == '')
      alert('Enter Subject and Message')
    
    else{
      btn.html('Please wait..')
      btn.attr('disabled', 'disabled')
      $.ajax({
        url: '/conversations/send-generic-message',
        type: 'POST',
        data:{
          subject: subject,
          message: body,
          recipients: recipients
        },
        success: function(resp){
          if(resp != 'false')
            modal.modal('hide')
          else
            alert('Something went Wrong, Please try again')

          btn.attr('disabled', false)
          btn.html('Send Message')  
        }
          
      });
    }
  });
}

app.fn.show_generic_message_modal = function(event){
  modal = $('#send_message_generic_modal')
  btn = $(event.target)
  app.btn = btn
  modal.find('.header-text').html(btn.attr('data-message-header'))

  modal.find('#message_recipients').val(btn.attr('data-message-recipients'))

  modal.find('#message_subject').val(btn.attr('data-message-subject'))

  modal.modal('show')

  app.fn.bind_click_event_on_modal_btn('#send_message_generic_modal')

}

function deg2rad(deg) {
  return deg * (Math.PI/180)
}

// pass a pait of latitude and logitude to get the distance
app.fn.distance_between_location = function(lat1, lon1, lat2, lon2){
  // earth's radius
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2-lat1);  // deg2rad below
  var dLon = deg2rad(lon2-lon1); 
  var a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
    Math.sin(dLon/2) * Math.sin(dLon/2)
    ; 
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  var d = R * c; // Distance in km
  return d;
}


  

  