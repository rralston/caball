
var Projects = {
  
  init: function () {
    console.log("init projects");
  },
  
  Show: {
    init: function () {
      console.log("init show project");   
      Projects.Show.handlers();
      Projects.Show.initFlow();
    },
    
    handlers: function() {
      
      
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
            //node.css({'-webkit-transform': 'perspective(800px) rotateY(30deg)'} )
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
              loop: true,
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
      
      Projects.Show.flowHandlers();
      
    }
    
  }
  
}