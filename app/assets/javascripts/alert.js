var Alert = {
  newAlert: function (type, notice) {
    $('#bootstrap-alert-placeholder').html('<div class="alert alert-' + type + '"><a class="close" data-dismiss="alert">×</a><span>'+notice+'</span></div>');
    $('.alert').alert();
    // We have to set our own timeout for closing the alert
    window.setTimeout(function() { $(".alert").alert('close'); }, 10000);
  }
}
