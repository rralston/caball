$(function(){
    pagesInitialize();
});
$(document).on("page:load",function(){
    pagesInitialize();
});
function pagesInitialize() {
    $('.selectpicker').selectpicker();
    $('.slider').slider();
}