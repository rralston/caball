// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require users/bootstrap-lightbox.js
//= require projects/numerous-2.1.1.js
//= require projects/slider.js
//= require application/sliding.form.js
//= require users/jquery.form.js
//= require rails.validations
//= require_directory .
//= require init
//= require jquery.remotipart
//= require plugins/manifest.js
//= require social-share-button
//= require jquery-fileupload/basic

$( document ).tooltip({ 
		hide: false, 
		position: {
	        my: "center top+15",
	        at: "center bottom",
	        using: function( position, feedback ) {
	          $( this ).css( position );
	          $( "<div>" )
	            .addClass( "arrow" )
	            .addClass( feedback.vertical )
	            .addClass( feedback.horizontal )
	            .appendTo( this );
        }}});
jQuery(document).ready(function() {
  jQuery("abbr.timeago").timeago();
  jQuery(".timeago").timeago();
});
