var Global = {
  
  init: function () {
    console.log("global init");
    Global.handlers();
  },
  
  handlers: function() {
    
    /* For adding clickable search button */
   $('.widgets .search .icon-search').on('click', function() {
     console.log("clicked");
     $('#user_search').submit();
   });
   
  }
  
}
