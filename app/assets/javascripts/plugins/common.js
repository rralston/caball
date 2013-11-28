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
  }).on('changeDate', function(ev) {
    // this will make the validation check happen by triggering focusout
    $(ev.target).focus();
    $(ev.target).data('datepicker').hide();
    $(ev.target).trigger('focusout');
  });
}

app.fn.initialize_time_autocomplete = function(element){
  element.timeAutocomplete({
    formatter: 'ampm',
    empty:  {
              h: '12',
              m: '00',
              sep: ':',
              postfix: ' PM'
            }
  });
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
        $(input_selector).trigger('keypress');
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
      btn.html('Please wait..');
      btn.attr('disabled', 'disabled');
      $.ajax({
        url: '/conversations/send-generic-message',
        type: 'POST',
        data:{
          subject: subject,
          message: body,
          recipients: recipients
        },
        success: function(resp){
          if(resp != 'false'){
            alert('Message sent successfully');
            modal.modal('hide');

            // if the conversations page, open the sent items.
            if( $("a[href=#conversation-tab-sent]").is(":visible") ){
              $("a[href=#conversation-tab-sent]").trigger('click');
            }
              
          }else{
            alert('Something went Wrong, Please try again');
          }
          btn.attr('disabled', false);
          btn.html('Send Message');
        }
          
      });
    }
  });
}

app.fn.show_generic_message_modal = function(event){
  modal = $('#send_message_generic_modal')
  btn = $(event.target)
  app.btn = btn

  recipients = btn.attr('data-message-recipients')
  if (recipients == ''){
    error_message = btn.attr('data-recipients-error')
    if (typeof error_message == 'undefined' || error_message == ''){
      alert('No recipients found');
    }else{
      alert(error_message)
    }

  }else{
    modal.find('.header-text').html(btn.attr('data-message-header'))

    modal.find('#message_recipients').val(btn.attr('data-message-recipients'))

    modal.find('#message_subject').val(btn.attr('data-message-subject'))

    modal.modal('show')

    app.fn.bind_click_event_on_modal_btn('#send_message_generic_modal')
  }

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

  // if they have any input inside them, add listener to that aswell.
  // this is for the taggit plugin cases.
  $('body').on('focus', selector+' input', function(event) {
    var div;
    div = $(event.target).closest('.hinted');
    msg = div.attr('data-hint');
    app.hint_div = $('<div>').html(msg).addClass('hint_msg');
    app.hint_div.insertAfter(div);
  });

  $('body').on('focusout', selector, function(event) {
    app.hint_div.remove();
    $('.hint_msg').remove();
  });

  $('body').on('focusout', selector+' input', function(event) {
    app.hint_div.remove();
    $('.hint_msg').remove();
  });
}
  
app.fn.init_super_roles_select_handler = function(super_role_selector_class, sub_roles, sub_role_selector_class, super_sub_roles){

  handle_super_sub_roles = typeof sub_role_selector_class != 'undefined' && typeof super_sub_roles != 'undefined'


  $('body').on('change', '.'+super_role_selector_class, function(event){

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

      if(handle_super_sub_roles){
        // hide super_sub_role container also.
        super_sub_role_container = $(event.target).closest('.control-group').find('.super_sub_role_container');

        super_sub_role_select = super_sub_role_container.find('select');
        // initially hide the select and empty options
        super_sub_role_container.hide();
        super_sub_role_select.html('');
        super_sub_role_select.val('');
      }

      // check if the role has sub roles.
      if(_.size(sub_roles[selected_val]) > 0){

        // build options
        options = '';
        _.each(sub_roles[selected_val], function(value, key){
          options += '<option value="' + value + '">' + key + '</option>';
        });

        sub_role_select.html(options);

        sub_role_select.trigger('change');

        sub_role_container.show();
      }

      app.fn.check_and_trigger_fan_selection()

      if(selected_val == 'Cast'){
        $.event.trigger({
          type: 'CastRoleSelected',
          target: event.target
        });
      }else{
        $.event.trigger({
          type: 'NonCastRoleSelected',
          target: event.target
        });
      }

      app.fn.adjust_slider_height();
    }
  });

  if(handle_super_sub_roles){
    // handler for handling sub role and showing third level super sub role
    $('body').on('change', '.'+sub_role_selector_class, function(event){

      
      // if case is to prevent the function to be called when the chil select are chaged and event propagates.
      if($(event.target).hasClass(sub_role_selector_class)){

        select_div = $(event.target)
        selected_sub_role_val = select_div.val()
        // selected_sub_role_val = $(event.target).val();
        super_sub_role_container = $(event.target).closest('.control-group').find('.super_sub_role_container');

        super_sub_role_select = super_sub_role_container.find('select');
        // initially hide the select and empty options
        super_sub_role_container.hide();
        super_sub_role_select.html('');
        super_sub_role_select.val('');

        // check if the role has sub roles.
        if(_.size(super_sub_roles[selected_sub_role_val]) > 0){
          
          // build options
          options = '';
          _.each(super_sub_roles[selected_sub_role_val], function(value, key){
            options += '<option value="' + value + '">' + key + '</option>';
          });

          super_sub_role_select.html(options);

          super_sub_role_container.show();

          app.fn.adjust_slider_height();
        }
      }
    });
  }

  
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

app.fn.init_jcrop = function(element, parent, original_width, original_height, original_image_url, aspect_ratio){

  // this will contain the parent of the image that is being cropped. User for resetting the crop.
  app.cropper_parent = parent

  // these global variable are used in the handler after cropping is done. Check app.fn.crop_now_method
  // original image that is being cropped
  app.cropper_original_image_url =  original_image_url
  app.cropper_original_width    = original_width
  app.cropper_original_height   = original_height

  if( typeof aspect_ratio == 'undefined' ){
    aspect_ratio = '16:9'
  }


  ar_width = parseInt( aspect_ratio.split(':')[0] )
  ar_height = parseInt( aspect_ratio.split(':')[1] )

  $('#crop_preview_area').attr('src', original_image_url)
  if( aspect_ratio == '1:1' ){

    // this is for the profile picture
    prev_div_width = 100;
    prev_div_heigth = 100;

    app.main_prev_width = 100;
    app.main_prev_height = 100;

  }else if( aspect_ratio == '16:9' ){

    prev_div_width = 160;
    prev_div_heigth = 90;

    app.main_prev_width = 160;
    app.main_prev_height = 90;

  }else if( aspect_ratio == '13:6' ){

    prev_div_width = 130;
    prev_div_heigth = 60;

    app.main_prev_width = 130;
    app.main_prev_height = 60;

  }
  else if( aspect_ratio == '4:3' ){
    
    prev_div_width = 120;
    prev_div_heigth = 90;

    app.main_prev_width = 160;
    app.main_prev_height = 120;

  }else if( aspect_ratio == '128:69' ){
    
    prev_div_width = 128;
    prev_div_heigth = 69;

    app.main_prev_width = 128;
    app.main_prev_height = 69;

  }else{
    
    prev_div_width = 100;
    prev_div_heigth = 100;

    app.main_prev_width = 150;
    app.main_prev_height = 150;

  }
  
  $('#crop_preview_area, .prev_container .crop_preview_container').css({
    width: prev_div_width + 'px',
    height: prev_div_heigth + 'px'
  });

  $('#crop_preview_area').css({
    marginLeft: '0px',
    marginTop: '0px'
  });

  // intialze crop values with null
  app.crop_values = {
    x: null,
    y: null,
    w: null,
    h: null
  }

  console.log(original_width)
  console.log(original_height)

  element.Jcrop({
    trueSize: [original_width, original_height],
    aspectRatio: ar_width / ar_height,
    boxWidth: 500,
    boxHeight: 250,
    onSelect: function(c){
      updateCropValues(c)
    },
    onChange: function(c){
      updateCropValues(c)
    }
  }, function(){
    app.jcrop_object = this;
  });

  updateCropValues = function (c){
    app.crop_values.x = c.x
    app.crop_values.y = c.y
    app.crop_values.w = c.w
    app.crop_values.h = c.h
    $('#crop_image_modal').find('.btn.crop_now').show()

    var rx = prev_div_width / c.w;
    var ry = prev_div_heigth / c.h;

    $('#crop_preview_area').css({
      width: Math.round(rx * original_width) + 'px',
      height: Math.round(ry * original_height) + 'px',
      marginLeft: '-' + Math.round(rx * c.x) + 'px',
      marginTop: '-' + Math.round(ry * c.y) + 'px'
    });
  }

  return app.jcrop_object;
}


app.fn.init_image_crop_handlers = function(){

  $('body').on('click', '.btn.crop_image', function(event) {
    var control_group_div, crop_values, image_container, original_height, original_image_url, original_width;
    
    control_group_div = $(event.target).closest('.control-group');
    image_container = control_group_div.find('.image_preview_container');
    
    original_image_url = $(event.target).attr('data-orgImgUrl');
    
    original_width = $(event.target).attr('data-orgWidth');
    original_height = $(event.target).attr('data-orgHeight');

    aspect_ratio = $(event.target).attr('data-ar')
    
    app.original_crop_values = {
      x: control_group_div.find('input.crop_x').val(),
      y: control_group_div.find('input.crop_y').val(),
      w: control_group_div.find('input.crop_w').val(),
      h: control_group_div.find('input.crop_h').val()
    };
    
    $('#crop_image_modal').on('shown', function() {
      // reset the style properties on the image tag
      $('#crop_image_modal').find('#cropping_image').attr('style','display: none; visibility: hidden; width: none; height: none; max-width: none; max-height: none;')

      app.fn.init_jcrop($('#crop_image_modal').find('#cropping_image'), control_group_div, original_width, original_height, original_image_url, aspect_ratio);
    });
    
    $('#crop_image_modal').on('hidden', function() {
      if(typeof app.jcrop_object != 'undefined' )
        app.jcrop_object.destroy();
    });
    
    $('#crop_image_modal').find('#cropping_image').attr('src', original_image_url);
    $('#crop_image_modal').modal('show');
    
    return false;
  });

  // $('body').on('click', '.btn.reset_crop', function(event) {
  //   app.fn.reset_cropped_image("150px", "150px");
  //   return false;
  // });

}


app.fn.crop_now = function(){
  // app.cropper_parent, app.crop_values, app.copper_original_image_url are set by the app.fn.init_jcrop method
  app.cropper_parent.find('.crop_x').val(app.crop_values.x);
  app.cropper_parent.find('.crop_y').val(app.crop_values.y);
  app.cropper_parent.find('.crop_w').val(app.crop_values.w);
  app.cropper_parent.find('.crop_h').val(app.crop_values.h);

  img_prev_div = app.cropper_parent.find('.image_preview_container');

  img_prev_div.attr('src', app.cropper_original_image_url);

  img_prev_div.css({
    width: Math.round(( app.main_prev_width / app.crop_values.w) * app.cropper_original_width) + 'px',
    height: Math.round(( app.main_prev_height / app.crop_values.h) * app.cropper_original_height) + 'px',
    marginLeft: '-' + Math.round(( app.main_prev_width / app.crop_values.w) * app.crop_values.x) + 'px',
    marginTop: '-' + Math.round(( app.main_prev_height /app.crop_values.h) * app.crop_values.y) + 'px'
  });

  app.cropper_parent.find('.btn.reset_crop').show()
}

  
// app.fn.reset_cropped_image = function(width, height) {
//   var control_group_div, image_container, parent;
//   control_group_div = app.cropper_parent.closest('.control-group');
//   image_container = control_group_div.find('.image_preview_container');
//   image_container.css({
//     width: width,
//     height: height,
//     marginLeft: "0px",
//     marginTop: "0px"
//   });
//   // parent = control_group_div;
//   // parent.find('.crop_x').val('');
//   // parent.find('.crop_y').val('');
//   // parent.find('.crop_w').val('');
//   // parent.find('.crop_h').val('');
// };

app.fn.print_options_for_select = function(options_array, selected_option){
  string = '';

  _.each(options_array, function(value, key){

    if( typeof selected_option != 'undefined' && value == selected_option){
      string = string + '<option value="'+ value +'" selected>'+ key +'</option>';
    }else{
      string = string + '<option value="'+ value +'">'+ key +'</option>';
    }

  });

  return string;
}

app.fn.set_checkbox_limit = function(selector, limit){
  $('body').on('click', selector, function(event){
    var selected_inputs_size = $(selector+':checked').size()
    if(selected_inputs_size > limit)
      return false;
    else
      return true

  });
}

app.fn.hard_rest_crop_values = function(element, width, height){
  element.find('.crop_x').val('');
  element.find('.crop_y').val('');
  element.find('.crop_w').val('');
  element.find('.crop_h').val('');

  image_container = element.find('.image_preview_container');
  image_container.css({
    width: width,
    height: height,
    marginLeft: "0px",
    marginTop: "0px"
  });
}


app.fn.check_if_photo_uploaded = function(selector){
  var to_return = true
  $('.photo_required_error').remove();
  $(selector).each(function(){

    control_group_div = $(this).closest('.control-group');
    remove_field = control_group_div.parent().find('input[type=hidden].numerous-remove-field')
    // this is present if the element is added via numerous remove plugin dynamically

    if($(this).val() == '' && control_group_div.find('.image_preview_container').attr('src') == '' ) {

      if ((remove_field.size() > 0) && (remove_field.val() == 1)){
        to_return = true;
      }else{
        to_return = false;
        $('<label class="message error photo_required_error">Please upload an image</label>').insertAfter($(this));  
      }
      
    }
  });
  return to_return;
}

app.fn.handle_guilds_dropdown = function(select_selector, input_selector){
  // remember, the select and input field should be under the same parent DIV in HTML
  $('body').on ('change', select_selector, function(event){
    select     = $(event.target);
    selected   = select.val();
    parent     = select.parent();
    text_field = parent.find('input'+input_selector);
    text_field.val('');
    text_field.hide();
    if(selected != 'Other'){
      text_field.val(selected);
      // text_field.show();
    }else{
      text_field.show();
    }
  });
}


// function to add datepicker to from and to date fields in the app
app.fn.add_chained_datepicker = function(start_selector, end_selector, format){
  var nowTemp = new Date();
  var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
  
  var format = 'yyyy-mm-dd'

  var checkin = $(start_selector).datepicker({
    format: format,
    startDate: new Date(),
    onRender: function(date) {
      return date.valueOf() < now.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function(ev) {
    if (ev.date.valueOf() > checkout.date.valueOf()) {
      var newDate = new Date(ev.date)
      newDate.setDate(newDate.getDate());
      // checkout.setValue(newDate);
      checkout.setStartDate(newDate);
    }
    $(start_selector).focus();
    checkin.hide();
    $(start_selector).trigger('focusout');
    // $(end_selector)[0].focus();
  }).data('datepicker');

  var checkout = $(end_selector).datepicker({
    format: format,
    onRender: function(date) {
      return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function(ev) {
    $(end_selector).focus();
    checkout.hide();
    $(end_selector).trigger('focusout');
  }).data('datepicker');

  window.data = checkout;
}


app.fn.bind_show_url_name = function(selector, target){

  var options = {
    callback: function (value) {
      make_ajax_call(value, $(this));
    },
    wait: 1000,
    highlight: true,
    captureLength: 2
  }

  function make_ajax_call(val, field){
    $.ajax({
      url: '/check_url_param',
      data:{
        value: val,
        entity: field.attr('data-entity'),
        entity_id: field.attr('data-entityid')
      },
      success: function (resp) {
        $(target).show();
        $(target).find('.url_param').html(resp);
      }
    });
  }
    

  $(selector).typeWatch(options);

  // var typewatchTimer;

  // $('body').on('keyup', selector, function(event){
  //   field   = $(event.target)
  //   val     = field.val()
  //   to_show = val.replace(/ /gi, '-').toLowerCase()

  //   // clear timer first
  //   window.clearInterval(typewatchTimer);
  //   typewatchTimer = window.setInterval(make_ajax_call(val, field), 1000);
    
  //   // $(target).show()
  //   // $(target).find('.url_param').html(to_show)
  // });

  // $('body').on('focusout', selector, function(event){
  //   field   = $(event.target)
  //   val     = field.val()

    
  // });
}

app.fn.check_and_trigger_fan_selection = function(){
  // if the primary role is changed
  if( $('.super_role_select:nth(0)').val() == 'Fan') {
    $.event.trigger({
      type: 'FanSelection'
    });
  }else{
    $.event.trigger({
      type: 'NonFanSelection'
    });
  }
}

app.fn.mark_finished_intro = function( step_finished, user_id ){
  $.ajax({
    url: '/people/'+user_id+'.json',
    type: 'post',
    data:{
      user: {
        finished_intro_state: step_finished
      }
    },
    success: function(data){
      return true;
    } 
  })
}