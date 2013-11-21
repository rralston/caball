

var Users = {
  
  init: function () {
    console.log("init Users");
  },
  
  Edit: {
    init: function () {
      console.log("init edit user");
      Users.Edit.handlers();
    },
    
    handlers: function () {
      
      // When user clicks on tab to go to next part of form, they're data will be uploaded/saved
      // For now, only if there aren't errors in the form
      /* We are scrapping this for now
      $('#navigation li').on('click', function() {
        if(!$('#formElem').data('errors')){
          $('#formElem').ajaxSubmit({
            dataType: 'json'
          });
        }
      });
      */

      app.fn.initalize_location_click_handler('#locate', 'input#user_location')
      
      // For User Edit form - slides when you press tab on the last input
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
      
      // For user form - if there are errors don't allow the user to submit
      $('#submit-user-form').bind('click',function(){
        if($('#formElem').data('errors')){
          Alert.newAlert('error', 'Please go back and correct any errors.');
          return false;
        } 
      });
      
      /* Update the Roles when the user changes their selection */
     
      $('.talent-select').on('change', function() {
        var value = $(this).val();
        var index = $(this).data('index');
        $('.step.roles .talent-label[data-index=' + index + ']').text(value);
        var actor = false;
        $characteristics = $('.actor-characteristics');
        $('.talent-select').each(function(index) {
          if ($(this).val() === 'Actor')  {
            actor = true;
          }
        });
        
        if (!actor && !$characteristics.hasClass('hidden') ) {
          $characteristics.addClass('hidden');
        } 
        if (actor) {
          if ($characteristics.hasClass('hidden')) {
            $characteristics.removeClass('hidden');
          }
        }
      });
      
      Users.Edit.init_numerous();
    },

    init_numerous: function() {
    /* Add handler for numerous.js if we're adding additional entries to form so that it resizes 
         div height */
      Numerous.init({
        'photos-list' : {
          'add' : function(added_form_element){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);

            app.fn.init_user_photos_upload(added_form_element.find('input[type=file]'))
          },
  
          'remove' : function(form){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);
          }
        },
        'videos-list' : {
          'add' : function(form){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);
          },
  
          'remove' : function(form){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);
          }
        },
        'talents-list': {
          'add': function(added_form_element){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);
            added_form_element.find('.super_role_select').trigger('change')

            added_talents = $('.user-talent').length
            new_talents = Numerous.count(['talents-list'])

            // if total talents are above 2 hide the add more option
            if ((added_talents + new_talents) >= 2){
              $('a#add-to-talents-list').hide()
            }

            $('.all-roles-container.have_error').removeClass('have_error')

            app.fn.check_and_trigger_fan_selection()
            
          },
          'remove': function(removed_form_element){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);

            added_talents = $('.user-talent').length
            new_talents = Numerous.count(['talents-list'])

            removed_form_element.find('.super_role_select').removeClass('super_role_select')

            // if total telents is less than 3 show option to add more talent
            if ((added_talents + new_talents) < 2){
              $('a#add-to-talents-list').show()
            }
          
            app.fn.check_and_trigger_fan_selection()
          }
        }
      });
  }
    
  },


  
  Show: {
    init: function () {
      console.log("init show users");   
      Users.Show.handlers();
      Users.Show.modalHandlers();
      
      $('span[data-link=updates]').trigger('click');
    },
    
    handlers: function () {
      
      $('.user-menu').on('click', function() {
        var link = $(this).data('link');
        Users.Show.displayContent(link, $(this));
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
          
          var top = $('.blog-arrow').eq(index).offset().top - $('.drawer-content').offset().top;
          
          $(this).css('top', top);
          
        });
      }
      
      
      $(window).load(rearrangeImages);
      rearrangeImages();
    },
    
    displayContent: function(link, menuItem) {
      
      var id = $('#user-body').data('id');
      console.log(link);
      
      $.ajax({
        url: '/users/' + id,
        contentType: "application/json; charset=utf-8",
        type: 'GET',
        context: menuItem,
        data: {
          'link': link
        },
        dataType: 'json',
        success: function(data) {
          console.log(data);
          if(data.success) {
            $('.user-body .body-content-container').html(data.html);
            $('.user-menu').removeClass('active');
            $(this).addClass('active');
            
            if($(this).data('link') === 'reel')
              Global.initFlow();
              
            if($(this).data('link') === 'updates')
              Users.Show.styleUpdates();
            
          }
            
          else 
            Alert.newAlert("error", "There was an error in processing");
        },
        error: function() {
          Alert.newAlert("error", "There was an error in processing");
        }
      });
      
    },
    
    modalHandlers: function () {
      
      /* Photo carousel for the photos modal */
      $('#photos-modal').on('shown', function () {
        $('#photoCarousel').carousel(0);
        $("body").keydown(function(e) {
          if(e.keyCode == 37) { // left
            $('#photoCarousel').carousel('prev');
          }
          else if(e.keyCode == 39) { // right
            $('#photoCarousel').carousel('next');
          }
        });
      });

      $('.role-more a').on('click', function () {
        // Now we have to figure out whether we'll display role 1 or role 2
        // We can do that from figuring out who our parent is and we'll have to 
        // iterate up the DOM tree to check
        console.log("clicked");
        var tempNode = $(this);
        while(!tempNode.hasClass('container-fluid')) { // How we know we've gone too far up
          if (tempNode.hasClass('role1')) {
            $('#role1-modal').modal( {
              keyboard: true
            }).css({
                'margin-left': function () {
                    return -($(this).width() / 2);
                  }
                });
            return;
          } else if (tempNode.hasClass('role2')) {
            $('#role2-modal').modal( {
              keyboard: true
            }).css({
                'margin-left': function () {
                    return -($(this).width() / 2);
                  }
                });
            return;
          }
          tempNode = tempNode.parent();
        }
      }); 
      
      $('.video-more a').on('click', function () {
        // Now we have to figure out which video to display
        // We can do that from figuring out who our parent is and we'll have to 
        // iterate up the DOM tree to check
        console.log("clicked");
        var tempNode = $(this);
        while(!tempNode.hasClass('container-fluid')) { // How we know we've gone too far up
          if (tempNode.hasClass('video-more-button')) {
            var videoNum = tempNode.data('video');
            $('#video-modal-' + videoNum).modal( {
              keyboard: true
            }).css({
                'margin-left': function () {
                    return -($(this).width() / 2);
                  }
                });
            return;
          }
          tempNode = tempNode.parent();
        }
      });  
    },
    
    /* This resizes the roles boxes so that they're all equal height and have equal proportions */
    equalHeights: function(selector) {
      
      $(selector).height('auto');
      var maxHeight=$(selector).parent().height();
      $(selector).each(function(){
          if($(this).height()>maxHeight){
              maxHeight=$(this).height();
          }
      });
     
      $(selector).height(maxHeight);
    },
    
    /* This resizes the roles boxes so that they're all equal width and have equal proportions */
    equalWidths: function(selector) {
      
      var maxWidth=$(selector).parent().width();
      $(selector).width('auto');
      $(selector).each(function(){
          if($(this).width()>maxWidth){
              maxWidth=$(this).width();
          }
      });
     
      $(selector).width(maxWidth);
    }
    
  },
  
  Index: {
    
    init: function() {
      Users.Index.handlers();
    },
    
    handlers: function() {
      
      /* We want to catch the search input and use ajax to display search results instead */
      $('#user_search input').on( 'keypress', function(e) {
        if(e.charCode == 13) {
          
          Users.Index.ajaxSearch();
          return false;
        }
      });
      
      $('.users-search .icon-search').on('click', function() {Users.Index.ajaxSearch();});
      
    },
    
    ajaxSearch: function() {
      var searchTerm = $('.user-title-input').val();  
      var searchLocation = $('.location-input').val();
      var searchTalents = $('.talents-input').val();
      
      var searchTalent;
      if(searchTalents !== null) { searchTalent = searchTalents[0]; } // Right now we can only search for one talent
      /* Do the ajax call to get results from the server */
      $.ajax({
        url: '/users',
        contentType: "application/json; charset=utf-8",
        type: 'GET',
        data: {              
          'q[name_cont]': searchTerm,
          'q[location_cont]': searchLocation,  
          'q[talents_name_cont]': searchTalent,          
        },
        dataType: 'json',
        success: function(data) {
          console.log(data);
          if(data.success) {
            $('.users-search .search-results').html(data.html);
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
    
  }
    
}