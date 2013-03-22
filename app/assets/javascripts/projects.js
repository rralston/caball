
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
      $(window).resize(Projects.Show.equalHeights);
      $(window).load(Projects.Show.equalHeights);
      
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
      
    },
    
    /* This resizes the roles boxes so that they're all equal height and have equal proportions */
    equalHeights: function() {
      
      var maxHeight=0;
      $('.roles-row .roles .well').height('auto');
      $('.roles-row .roles .well').each(function(){
          if($(this).height()>maxHeight){
              maxHeight=$(this).height();
          }
      });
     
      $('.roles-row .roles .well').height(maxHeight);
    }
    
  },
  
  Index: {
    
    init: function() {
      console.log("Project search init");
      Projects.Index.handlers();
      
    },
    
    handlers: function() {
      console.log("projects handlers init");
      
      /* We want to catch the search input and use ajax to display search results instead */
      $('#project_search input').on( 'keypress', function(e) {
        if(e.charCode == 13) {
          Projects.Index.ajaxSearch();
        }
      });
      
      $('#project_search .icon-search').on('click', Projects.Index.ajaxSearch);
      
      $(window).load(Projects.Index.equalHeights);
      $(window).resize(Projects.Index.equalHeights);
      
    },
    
    ajaxSearch: function() {
      var searchTerm = $('.project-title-input').val();  
      var searchLocation = $('.location-input').val();
      var searchRoles = $('.roles-input').val();
      var searchGenres = $('.genres-input').val()
      var searchRole, searchGenre;
      if(searchRoles !== null) { searchRole = searchRoles[0]; }
      if(searchGenres !== null) { searchGenre = searchGenres[0]; }
      
      /* Do the ajax call to get results from the server */
      $.ajax({
        url: '/projects',
        contentType: "application/json; charset=utf-8",
        type: 'GET',
        data: {              
          'q[title_cont]': searchTerm,
          'q[location_cont]': searchLocation,
          'q[roles_id_eq]': searchRole,
          'q[genre_cont]': searchGenre
          
        },
        dataType: 'json',
        success: function(data) {
          console.log(data);
          if(data.success) {
            $('.projects-search .search-results').html(data.html);
            $('.projects-search .projects-box img').load(Projects.Index.equalHeights);
          }
          else 
            Alert.newAlert("error", "There was an error processing your search");
       
        },
        error: function() {
          Alert.newAlert("error", "There was an error processing your search");
        }
      });
      return false;
    },
    
    /* This resizes the project boxes so that they're all equal height and have equal proportions */
    equalHeights: function() {
      
      var maxHeight=0;
      $('.projects-search .projects-box').height('auto');
      $('.projects-search .projects-box').each(function(){
          if($(this).height()>maxHeight){
              maxHeight=$(this).height();
          }
      });
      
      $('.projects-search .projects-box .project-description').height('auto');
      $('.projects-search .projects-box').height(maxHeight);
      maxHeight = 0;
      $('.projects-search .projects-box .project-description').each(function(){
          if($(this).height()>maxHeight){
              maxHeight=$(this).height();
          }
      });
      $('.projects-search .projects-box .project-description').height(maxHeight);
    }
  }
  
}