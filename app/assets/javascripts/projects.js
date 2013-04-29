
var Projects = {
  
  init: function () {
    console.log("init projects");
  },
  
  Show: {
    init: function () {
      console.log("init show project");   
      Projects.Show.handlers();
      
      Global.initFlow();
      Projects.Show.modalHandlers();
      Projects.Show.styleUpdates();
    },
    
    handlers: function() {
      $(window).resize(Projects.Show.equalHeights);
      $(window).load(Projects.Show.equalHeights);
      
    },
    
    modalHandlers: function() {
      
      /* So that the messaging modal sizes appropriately */
      $('#message-modal').on('shown', function () {
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
      console.log("Project search init");
      Projects.Index.handlers();
      Projects.Index.modalHandlers();
      
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