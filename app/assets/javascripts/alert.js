var Alert = {
  newAlert: function (type, notice) {
    $('#bootstrap-alert-placeholder').html('<div class="alert alert-' + type + '"><a class="close" data-dismiss="alert">×</a><span>'+notice+'</span></div>');
  }
}
