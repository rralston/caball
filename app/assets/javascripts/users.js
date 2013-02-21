

var Users = {
  
  init: function () {
    console.log("init Users");
  },
  
  Show: {
    init: function () {
      console.log("init show users");   
      Users.Show.handlers();
      Users.Show.roleModals();
    },
    
    handlers: function() {
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
      });
    },
    
    roleModals: function () {
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
            });
            return;
          } else if (tempNode.hasClass('role2')) {
            $('#role2-modal').modal( {
              keyboard: true
            });
            return;
          }
          tempNode = tempNode.parent();
        }
      });  
    }
    
  }
  
}