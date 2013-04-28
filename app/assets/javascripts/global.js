var Global = {
  
  init: function () {
    console.log("global init");
    Global.handlers();
    Global.modalHandlers();
  },
  
  handlers: function() {
    
    /* For adding clickable search button */
   $('.widgets .search .icon-search').on('click', function() {
     console.log("clicked");
     $('#user_search').submit();
   });
   $('.follow-button-handler').on('click', Global.ajaxFollow);
  },
    
  modalHandlers: function() {
    
    /* So that the messaging modal sizes appropriately */
    $('.message-modal').on('shown', function () {
      $(this).css({
      'margin-left': function () {
          return -($(this).width() / 2);
        }
      });
    });
    
    
    /* Event listeners for messaging modal buttons */
    $('#message-modal').on('shown', function () {
      $('input[value="Cancel"]').on('click', function () {
        $('#message-modal').modal('hide');
        return false;
      });
      
      $('#message-modal').on('hidden', function () {
        $('input[value="Cancel"]').off('click');
      });
    });
  },
  
  initFlow: function() {
    console.log("initflow");
    $(".royalSlider").royalSlider({
            addActiveClass: true,
            arrowsNav: false,
            controlNavigation: 'none',
            video: {
              autoHideBlocks: true,
              autoHideArrows: false,
              vimeoCode: '<iframe src="http://player.vimeo.com/video/%id%?byline=0&amp;portrait=0&amp;autoplay=1" width="WIDTH" height="HEIGHT" frameborder="no" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
            },
            fadeinLoadedSlide: false,
            keyboardNavEnabled: true,
            visibleNearby: {
              enabled: true,
              centerArea: 0.4,
              center: true,
              breakpoint: 650,
              breakpointCenterArea: 0.64,
              navigateByCenterClick: false
          },
      });  
    
    $('.rsSlide:first').addClass('rsActiveSlide');
    Global.flowHandlers();
    
  },
  
  ajaxFollow: function() {
    $(this).button('loading');
    $.ajax({
      url: $(this).attr('href'),
      type: $(this).data('method').toUpperCase(),
      contentType: 'application/json; charset=utf-8',
      success: function (data) {
          if(data.success) {
            if(data.created) {
              
               // We have to update which friendship to remove now
              newId = data.friendship.id;
              $('.follow-button-handler.stop-following').filter(testUser).attr('href', '/friendships/' + newId);
              $('#bootstrap-alert-placeholder').html('<div class="alert alert-success"><a class="close" data-dismiss="alert">×</a><span>'+data.notice+'</span></div>');
              $('.follow-button-handler').filter(testUser).button('reset');
              $('.follow-button-handler.stop-following').filter(testUser).removeClass('follow-button-hide');
              $('.follow-button-handler.start-following').filter(testUser).addClass('follow-button-hide');
              
              $('.fan-count').filter(testUser).text(data.fan_count);
              
              $('.alert').alert();
              // We have to set our own timeout for closing the alert
              window.setTimeout(function() { $(".alert").alert('close'); }, 5000);
            }
            else if (data.destroyed) {
              
              $('#bootstrap-alert-placeholder').html('<div class="alert fade in"><a class="close" data-dismiss="alert">×</a><span>'+data.notice+'</span></div>');
              $('.follow-button-handler').filter(testUser).button('reset');
              
              $('.follow-button-handler.stop-following').filter(testUser).addClass('follow-button-hide');
              $('.follow-button-handler.start-following').filter(testUser).removeClass('follow-button-hide');
              
              $('.fan-count').filter(testUser).text(data.fan_count);
              
              $('.alert').alert();
              // We have to set our own timeout for closing the alert
              window.setTimeout(function() { $(".alert").alert('close'); }, 5000);
            }
            else {
              $('.follow').filter(testUser).button('reset');
              $('#bootstrap-alert-placeholder').html('<div class="alert fade in alert-error"><a class="close" data-dismiss="alert">×</a><span>There was a problem following. Please try again...</span></div>');
            }
          }
          function testUser() {
            return $(this).data('user-id') == data.friendship.friend_id;
          }
      },
      error: function () {
        $('.follow').button('reset');
        $('#bootstrap-alert-placeholder').html('<div class="alert fade in alert-error"><a class="close" data-dismiss="alert">×</a><span>There was a problem following. Please try again...</span></div>');
      }
    });
    return false;
  },
  
  flowHandlers: function() {
      
    function adjustAngles(eventTrigger) {
      if (eventTrigger.currentTarget.hasOwnProperty('slider')) {
        var slider = eventTrigger.currentTarget.slider;
        var sliderData = eventTrigger.currentTarget;
      } else {
        var slider = $(eventTrigger.currentTarget).parents('.royalSlider');
        var sliderData = slider.data('royalSlider');
      }

      var offsetFromCenter = slider.find('.rsSlide.rsActiveSlide').offset().left;
      
      var slides = sliderData.slidesJQ;
      
      $.each(slides, function(index, node) {
        node.removeClass('left-slide');
        node.removeClass('right-slide');
  
        if (node.offset().left < offsetFromCenter) { 
          node.addClass('left-slide');
        }
        else if (node.offset().left > offsetFromCenter) { 
          node.addClass('right-slide')
        }
      });
      
    }
      
    /* I added some logic here so that we can have multiple sliders per page */
    $('.royalSlider').each(function(index) {
      slider = $(this).data('royalSlider');
      
      if(slider.slides[0] !== undefined) {
        slider.slides[0].holder.on('rsAfterContentSet', adjustAngles);
        slider.ev.on('rsAfterSlideChange', adjustAngles);
      }
    }); 
  }
}
