

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
      
      var ajaxFormOptions = { 
        success:      function(responseText, statusText, xhr, $form){ // post-submit callback 
                        console.log('status: ' + statusText + '\n\nresponseText: \n' + responseText + '\n\nThe output div should have already been updated with the responseText.'); 
                      } 
      }; 
      
      $('#formElem').ajaxForm(ajaxFormOptions);
      
      $('#navigation li').on('click', function() {
        console.log("submitting form ajaxly");
        $('#formElem').ajaxSubmit();
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
    }
  },
  
  Show: {
    init: function () {
      console.log("init show users");   
      Users.Show.handlers();
      Users.Show.modalHandlers();
    },
    
    handlers: function () {
      
      $('#message-modal').on('show', function () {
        $(this).css({
        'margin-left': function () {
            return -($(this).width() / 2);
          }
        });
      });
      
      $('#message-modal').on('shown', function () {
        $('input[value="Cancel"]').on('click', function () {
          $('#message-modal').modal('hide');
          return false;
        });
        
        $('#message-modal').on('hidden', function () {
          $('input[value="Cancel"]').off('click');
        });
      });
      
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
    }
    
  }
  
}