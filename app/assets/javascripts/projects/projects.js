
var Projects = {
  
  init: function () {
    console.log("init projects");
  },
  
  Edit: {
    
    init: function() {   
      Projects.Edit.handlers();
    },
    
    handlers: function() {
      // When user clicks on tab to go to next part of form, they're data will be uploaded/saved
      // For now, only if there aren't errors in the form.
      /* We are scrapping this for now
      $('#navigation li').on('click', function() {
        if(!$('#formElem').data('errors')){
          $('#formElem').ajaxSubmit({
            dataType: 'json'
          });
        }
      });
      */
      // For Project Edit form - slides when you press tab on the last input
      $('#formElem fieldset').each(function() {
          $this = $(this);
          $inputField = $this.find('.control-group').last().children().last();
          $inputField.on('keydown', function(e){
            if (e.which == 9){          
              var current = $('#steps').data('index');
              $('#navigation li:nth-child(' + (parseInt(current)+1) + ') a').click();
              /* force the blur for validation */
              $(this).blur();
              e.preventDefault();
            }
        });
      });
      
      /* Add handler for numerous.js if we're adding additional entries to form so that it resizes 
         div height  */
      Numerous.init({
        'roles-list' : {
          'add' : function(form){
            app.fn.resize_form()
            // app.fn.bind_change_event()
          },
  
          'remove' : function(form){
            app.fn.resize_form()
          }
        },
        'project_dates-list': {
          'add' : function(added_form_element){
            app.fn.resize_form()
            app.fn.initialize_date_picker('.date_field')
            $('.project-save-form').enableClientSideValidations()
            app.fn.initialize_time_autocomplete(added_form_element.find('.time_field'))
            
            new_imp_dates = Numerous.count(['project_dates-list'])

            // if total talents are above 2 hide the add more option
            if ((new_imp_dates) >= 3){
              $('a#add-to-project_dates-list').hide()
            }

          },
  
          'remove' : function(form){
            app.fn.resize_form()
            $('a#add-to-project_dates-list').show()
          }
        },
        'project_photos-list': {
          'add' : function(added_form_element){
            app.fn.resize_form()
            app.fn.init_image_file_uploader(added_form_element.find('input[type=file]'))
          },
  
          'remove' : function(form){
            app.fn.resize_form()
          }
        }
      });
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
      
      $('.projects-search .icon-search').on('click', Projects.Index.ajaxSearch);
      
    },
    
    ajaxSearch: function() {
      var searchTerm = $('.project-title-input').val();  
      var searchLocation = $('.location-input').val();
      var searchRoles = $('.roles-input').val();
      var searchGenres = $('.genres-input').val();
      var searchRole, searchGenre;
      if(searchRoles !== null) { searchRole = searchRoles[0]; } // Right now we can only search for one role
      if(searchGenres !== null) { searchGenre = searchGenres[0]; } // Right now we can only search for one genre
      
      /* Do the ajax call to get results from the server */
      $.ajax({
        url: '/projects',
        contentType: "application/json; charset=utf-8",
        type: 'GET',
        data: {              
          'q[title_cont]': searchTerm,
          'q[location_cont]': searchLocation,
          'q[roles_name_eq]': searchRole,
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
    }
  },

  validateGenre: function(){
    var hasError;
    if($('fieldset div #project_genre').val() && $('fieldset div #project_genre').val().length > 2){
      $('fieldset div #project_genre').addClass('has_errors')
      hasError = true;
    }else{
      $('fieldset div #project_genre').removeClass('has_errors')
    }
    return hasError;
  }
  
}