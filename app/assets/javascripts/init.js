/* This is a way to conditionally initialize certain js files depending on which controller and action are taking place */
/* Each js file represents a controller and has initializations for both the controller and individual actions */

PAGES = {
  common: {
    init: function() {
      console.log("sitewide init");
    }
  },
 
  users: {
    init: function() {
      Users.init();
    },
    
    edit: function () {
      Users.Edit.init();
    },
 
    show: function() {
      Users.Show.init();
    },
    
    index: function() {
      Users.Index.init();
    }
  },
 
  projects: {
    init: function() {
      Projects.init();
    },
 
    show: function() {
      Projects.Show.init();
    },
    
    index: function() {
      Projects.Index.init();
    }
  }
};
 
INIT = {
  exec: function( controller, action ) {
    var ns = PAGES,
        action = ( action === undefined ) ? "init" : action;
 
    if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) {
      ns[controller][action]();
    }
  },
 
  init: function() {
    var body = document.body,
        controller = body.getAttribute( "data-controller" ),
        action = body.getAttribute( "data-action" );
 
    INIT.exec( "common" );
    INIT.exec( controller );
    INIT.exec( controller, action );
  }
};
 
$( document ).ready( INIT.init );