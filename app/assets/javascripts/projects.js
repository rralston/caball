
var Projects = {
  
  init: function () {
    console.log("init projects");
  },
  
  Edit: {
    
    init: function() {
      console.log('edit project init');
      
      Numerous.init();
    }
  },
  
  Show: {
    
    init: function () {
      Projects.Show.handlers();
      
      Global.initFlow();
      Projects.Show.styleUpdates();
    },
    
    handlers: function() {
      
      $('.navigate-button').on('click', function() {
        var target = $(this).data('target');
        $('html, body').animate({scrollTop: $("#" + target).offset().top}, 2000);
      });
    },
    
    styleUpdates: function() {
      
      function rearrangeImages() {
        var baseRowOffset = 60;
        var deviationRowOffset = 100;
        
        $('.blog-post').each(function(index) {
          if(index % 2 == 1) {
            var offset = baseRowOffset + (Math.random() * deviationRowOffset);
            $(this).css('margin-top', offset + 'px');
          }
        });
        
        /* In order to handle really tall images */
       $('.blog-post').each(function(index) {
         if(index > 1) {
           var diff = $(this).offset().top - ($('.blog-post').eq(index - 2).offset().top + $('.blog-post').eq(index - 2).height());
           if(diff < 0) {
             $('.blog-post').eq(index-1).css('margin-bottom', (diff * -1) + 'px');
           }
         }
       });
        
        $('.blog-circle').not('.blog-circle-top').each(function(index) {
          
          var top = $('.blog-arrow').eq(index).offset().top - $('#comments').offset().top;
          
          $(this).css('top', top);
          
        });
      }
      
      
      $(window).load(rearrangeImages);
      rearrangeImages();
    },
    
  },
  
  Index: {
    
    init: function() {
      Projects.Index.handlers();
      
    },
    
    handlers: function() {
      
      /* We want to catch the search input and use ajax to display search results instead */
      $('#project_search input').on( 'keypress', function(e) {
        if(e.charCode == 13) {
          Projects.Index.ajaxSearch();
        }
      });
      
      $('#project_search .icon-search').on('click', Projects.Index.ajaxSearch);
      
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
  }
  
}