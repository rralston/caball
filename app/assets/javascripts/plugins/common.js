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

app.fn.initialize_date_picker = function(selector){
  $( selector ).datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    todayBtn: true,
    pickTime: false,
    startDate: new Date(),
  });
}

app.fn.initialize_time_autocomplete = function(selector){
  $(selector).timeAutocomplete();
}


app.fn.bind_report_event = function(){
  $('body').on('click', '.report-btn',  function(event){
    if(app.fn.check_current_user()){
      btn = $(event.target)
      btn.html('Please wait..')
      btn.attr('disabled', 'disabled')
      $.ajax({
        url: '/report',
        type: 'POST',
        data: {
          entity: btn.attr('data-entity'),
          id: btn.attr('data-id'),
          reason: $('#report_entity_reason').val()
        },
        success: function(resp){
          if(resp == 'true'){
           alert('Feedback received. Thank You for helping us') 
           btn.attr('disabled', false)
           btn.html('Report')
           $('#report-modal').modal('hide')
          }
        }
      });
    }
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

app.fn.show_read_more_modal = function(event){
  modal = $('#read_more_modal')
  btn = $(event.target)

  modal.find('.header-text').html(btn.attr('data-header'))

  modal.find('.modal-body').html(btn.attr('data-content'))

  modal.modal('show')
}

app.fn.bind_read_more_show = function(){
  $('body').on('click', '.read_more_btn', function(event){
    app.fn.show_read_more_modal(event)
  });
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

app.fn.jquerySerailize = function(form)
{
   var o = {};
   var a = form.serializeArray();
   $.each(a, function() {
       if (o[this.name]) {
           if (!o[this.name].push) {
               o[this.name] = [o[this.name]];
           }
           o[this.name].push(this.value || '');
       } else {
           o[this.name] = this.value || '';
       }
   });
   return o;
};

 app.fn.serializeJSON = function(form){
    var json = {}
    form.find('input, select').each(function(){
      var val
      if (!this.name) return;
 
      if ('radio' === this.type) {
        if (json[this.name]) { return; }
 
        json[this.name] = this.checked ? this.value : '';
      } else if ('checkbox' === this.type) {
        val = json[this.name];
 
        if (!this.checked) {
          if (!val) { json[this.name] = ''; }
        } else {
          json[this.name] = 
            typeof val === 'string' ? [val, this.value] :
            $.isArray(val) ? $.merge(val, [this.value]) :
            this.value;
        }
      } else {
        json[this.name] = this.value;
      }
    })
    return json;
  }


app.fn.initialize_cat_complete_search = function(selector, on_select_callback){
  $.widget( "custom.catcomplete", $.ui.autocomplete, {
      _renderMenu: function( ul, items ) {
        var that = this,
          currentCategory = "";
        $.each( items, function( index, item ) {
          if ( item.category != currentCategory ) {
            ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
            currentCategory = item.category;
          }
          that._renderItemData( ul, item );
        });
      }
    });

   $(selector).catcomplete({
    delay: 0,
    source: function(request, response){
      $.getJSON( "http://gd.geobytes.com/AutoCompleteCity?callback=?&q="+request.term, function(data){
        data.push(request.term) // this will push the search string into location category also
        custom_data =  _.map(data, function(item){
          return { label: item, value: item, category: 'Search by Location', type: 'location' } 
        });
        custom_data.push({ category: 'Search for Keyword', label: request.term, value: request.term, type: 'keyword' })
        response(custom_data)
      });
    },
    select: function(event, ui){
      on_select_callback(ui.item)
    },
    messages:{
      noResult: '',
      results: function(){}
    }
        
   });
}

app.fn.check_not_same_user = function(id, message){
  // returns true if current user id if different from passed id
  if(parseInt(app.current_user.id) == parseInt(id)){
    if(typeof message == 'undefined')
      message = "You can't continue with this action.";

    alert(message);
    return false;
  }else{
    return true;
  }

}

app.fn.check_current_user = function(){
  // need app.current_user to be set..!
  if(app.current_user)
    return true;
  else{
    alert('Please login to continue with the action');
    return false;
  }
}



app.fn.initialize_send_generic_message = function(){
  $('body').on('click', '.send-generic-message', function(event){
    if(app.fn.check_current_user())
      app.fn.show_generic_message_modal(event);
  });
}

app.fn.set_notification_check_time = function(element){
  $.ajax({
    url: '/users/set_notification_check_time',
    success: function(resp){
      if(resp=='true'){
        // remove set_time class on all those that have set_time class.
        $('.set_time').removeClass('set_time')
        // hide the notifications count displayed on the header
        $('.notstarwrap .notno').hide()
      }
    }
  })
}

app.fn.format_date = function(datetime){
  input = new Date(datetime)
  date = input.toLocaleDateString();
  time = input.toLocaleTimeString().replace(/([\d]+:[\d]{2})(:[\d]{2})(.*)/, "$1$3");
  todaysDate = new Date();

  // compare with todays date. if today return only tine
  if(input.setHours(0,0,0,0) == todaysDate.setHours(0,0,0,0)){
    return time
  }else{
    return date + '  ' + time
  }
}
  

// function that will listen for event of radion button which will help in showiing and hiding respective fields
// the target that has to be toggled should be given as data-target attribute.
app.fn.initialize_radio_toggler = function(){
  $('body').on('click', '.toggler_radio', function(event){

    btn = $(event.target)
    target = btn.attr('data-target')
    if(btn.is(":checked")){
      if(btn.attr('value')=='true'){
        $(target).show()
      }else if(btn.attr('value') == 'false'){
        $(target).hide()
      }
    }
  });
}


app.fn.init_form_elem_hints = function(selector){
  $('body').on('focus', selector, function(event) {
    var div;
    div = $(event.target).closest('.hinted');
    msg = div.attr('data-hint');
    app.hint_div = $('<div>').html(msg).addClass('hint_msg');
    app.hint_div.insertAfter(div);
  });

  $('body').on('focusout', selector, function(event) {
    app.hint_div.remove();
  });
}
  
app.fn.init_super_roles_select_handler = function(super_role_selector_class, sub_roles){

  $('body').on('change', $('.'+super_role_selector_class), function(event){

    // if case is to prevent the function to be called when the chil select are chaged and event propagates.
    app.selected = $(event.target)
    if($(event.target).hasClass(super_role_selector_class)){
      selected_val = $(event.target).val();
      sub_role_container = $(event.target).closest('.control-group').find('.sub_role_container');

      sub_role_select = sub_role_container.find('select');
      // initially hide the select and empty options
      sub_role_container.hide();
      sub_role_select.html('');
      sub_role_select.val('');
      // check if the role has sub roles.
      if(_.size(sub_roles[selected_val]) > 0){

        // build options
        options = '';
        _.each(sub_roles[selected_val], function(sub_role){
          options += '<option value="' + sub_role + '">' + sub_role + '</option>';
        });

        sub_role_select.html(options);

        sub_role_container.show();

        app.fn.adjust_slider_height();
      }
    }
  });
}

app.fn.adjust_slider_height = function(){
  var current = $('#steps').data('index');
  var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
  $('#steps').height(stepHeight);
}



app.fn.init_comment_image_file_uploader = function(element, url) {
  element.fileupload({
    url: url,
    type: 'POST',
    add: function(e, data) {
      var file, types;
      types = /(\.|\/)(jpe?g|png)$/i;
      file = data.files[0];
      if (types.test(file.type) || types.test(file.name)) {
        data.progress_div = $('#' + data.fileInput.attr('id')).closest('.tab-pane').find('.upload_progress');
        data.progress_div.show();
        
        data.control_group_div = $('#' + data.fileInput.attr('id')).closest('.tab-pane');
        data.image_container = data.control_group_div.find('.image_preview_container');
        
        data.image_container.attr('src', '');
        data.submit();
      } else {
        alert('The file you selected is not a jpeg or png image file');
      }
    },
    progress: function(e, data) {
      var progress;
      progress = parseInt(data.loaded / data.total * 100, 10);
      data.progress_div.find('.bar').css('width', progress + '%');
    },
    done: function(e, data) {
      var image_url;
      image_url = data.result['url'];
      
      data.url_field = data.control_group_div.find('.photo_url_div');
      data.url_field.val(image_url);
      
      data.image_container.attr('src', image_url);
      data.image_container.show();
      
      data.progress_div.hide();
    }
  });
};

app.fn.init_show_post_button_handler = function(){
  app.post_button_shown = false
  $('body').on('click', '.writeico a', function(event){
    app.post_button_shown = true
    $(event.target).closest('form').find('.post_comment_btn').show()
  });
}

app.fn.init_jcrop = function(element, parent, original_width, original_height){
  element.Jcrop({
    trueSize: [original_width, original_height],
    onSelect: function(c){
      parent.find('.crop_x').val(c.x)
      parent.find('.crop_y').val(c.y)
      parent.find('.crop_w').val(c.w)
      parent.find('.crop_h').val(c.h)
    },
    onChange: function(c){
      parent.find('.crop_x').val(c.x)
      parent.find('.crop_y').val(c.y)
      parent.find('.crop_w').val(c.w)
      parent.find('.crop_h').val(c.h)
    }
  });
}
  

