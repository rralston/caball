

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
        console.log($(this).val() + $(this).data('index'));  
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