

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
      $('#navigation li').on('click', function() {
        if(!$('#formElem').data('errors')){
          $('#formElem').ajaxSubmit();
        }
      });
      
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
      
      /* Add handler for numerous.js if we're adding additional entries to form so that it resizes 
         div height
       */
            
      Numerous.init({
        'photos-list' : {
          'add' : function(form){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step :eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);
          },
  
          'remove' : function(form){
            var current = $('#steps').data('index');
            var stepHeight = $('#steps .step :eq(' + (current - 1) + ')').height();
            $('#steps').height(stepHeight);
          }
        }
      });
    },
    
  },
  
  Show: {
    init: function () {
      console.log("init show users");   
      Users.Show.handlers();
      Users.Show.modalHandlers();
      $('div[data-link=about_me]').trigger('click');
    },
    
    handlers: function () {
      /* These are for keeping boxes equal widths/heights
       * Right now we need to add each handler -
       * we could probably replace this with an array of selectors that all should be the same height
       * and then a function that just handles them all.
       */
      $(window).resize( function() {
        Users.Show.equalWidths('.user-body .user-menu .item.name');
      });
      $(window).load( function() {
        Users.Show.equalWidths('.user-body .user-menu .item.name');
      });
      
      $(window).resize( function() {
        Users.Show.equalHeights('.follow-buttons div');
      });
      $(window).load( function() {
        Users.Show.equalHeights('.follow-buttons div');
      });
      
      $('.user-menu').on('click', function() {
        var link = $(this).data('link');
        $('.user-menu').removeClass('active');
        $(this).addClass('active');
        Users.Show.displayContent(link);
      });
    },
    
    displayContent: function(link) {
      var id = $('#user-body').data('id');
      console.log(link);
      
      $.ajax({
        url: '/users/' + id,
        contentType: "application/json; charset=utf-8",
        type: 'GET',
        data: {
          'link': link
        },
        dataType: 'json',
        success: function(data) {
          console.log(data);
          if(data.success)
            $('.user-body .content').html(data.html);
          else 
            Alert.newAlert("error", "There was an error in processing");
        },
        error: function() {
          Alert.newAlert("error", "There was an error in processing");
        }
      });
    },
    
    modalHandlers: function () {
      
      /* So that the messaging modal sizes appropriately */
      $('#message-modal').on('show', function () {
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
      
      $('.follow').on('click', ajaxFollow);
      
      function ajaxFollow() {
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
                  $('.follow.stop-following').attr('href', '/friendships/' + newId);
                  $('#bootstrap-alert-placeholder').html('<div class="alert alert-success"><a class="close" data-dismiss="alert">×</a><span>'+data.notice+'</span></div>');
                  $('.follow').button('reset');
                  $('.follow.stop-following').removeClass('hidden');
                  $('.follow.start-following').addClass('hidden');
                  
                  $('.alert').alert();
                  // We have to set our own timeout for closing the alert
                  window.setTimeout(function() { $(".alert").alert('close'); }, 2000);
                }
                else if (data.destroyed) {
                  
                  $('#bootstrap-alert-placeholder').html('<div class="alert fade in"><a class="close" data-dismiss="alert">×</a><span>'+data.notice+'</span></div>');
                  $('.follow').button('reset');
                  $('.follow.stop-following').addClass('hidden');
                  $('.follow.start-following').removeClass('hidden');
                  
                  $('.alert').alert();
                  // We have to set our own timeout for closing the alert
                  window.setTimeout(function() { $(".alert").alert('close'); }, 2000);
                }
                else {
                  $('.follow').button('reset');
                  $('#bootstrap-alert-placeholder').html('<div class="alert fade in alert-error"><a class="close" data-dismiss="alert">×</a><span>There was a problem following. Please try again...</span></div>');
                }
              }
          },
          error: function () {
            $('.follow').button('reset');
            $('#bootstrap-alert-placeholder').html('<div class="alert fade in alert-error"><a class="close" data-dismiss="alert">×</a><span>There was a problem following. Please try again...</span></div>');
          }
        });
        return false;
      }
    },
    
    modalHandlers: function () {
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
      
      var maxHeight=$(selector).parent().height();
      $(selector).height('auto');
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
          searchTerm = $(this).val();
          
          /* Do the ajax call to get results from the server */
          $.ajax({
            url: '/users',
            contentType: "application/json; charset=utf-8",
            type: 'GET',
            data: {
              'q[name_cont]': searchTerm
            },
            dataType: 'json',
            success: function(data) {
              console.log(data);
              if(data.success)
                $('.users-search .search-results').html(data.html);
              else 
                Alert.newAlert("error", "There was an error processing your search");
           
            },
            error: function() {
              Alert.newAlert("error", "There was an error processing your search");
            }
          });
          return false;
        }
      });
      
      
    }
    
  }
    
}