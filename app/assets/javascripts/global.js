var Global = {
  
  init: function () {
    console.log("global init");
    Global.handlers();
  },
  
  handlers: function() {
    
    /* For adding clickable search button */
   $('.widgets .search .icon-search').on('click', function() {
     console.log("clicked");
     $('#user_search').submit();
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
              autoHideArrows: false
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
          }
      });  
    
    $('.rsSlide:first').addClass('rsActiveSlide');
    Global.flowHandlers();
    
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
      
      slider.slides[slider.numSlides - 1].holder.on('rsAfterContentSet', adjustAngles);
      slider.ev.on('rsAfterSlideChange', adjustAngles);
    }); 
  }
}
