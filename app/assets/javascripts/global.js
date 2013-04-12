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
      
    function adjustAngles() {
      var offsetFromCenter = $('.rsSlide.rsActiveSlide').offset().left;
      
      var slides = slider.slidesJQ;
      
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
    var slider = $(".royalSlider").data('royalSlider');
    console.log(slider);
    
    slider.slides[slider.numSlides - 1].holder.on('rsAfterContentSet', adjustAngles);
    slider.ev.on('rsAfterSlideChange', adjustAngles);
    
  }
  
}
