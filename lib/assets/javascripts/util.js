(function(window, $) {
  var util = function() {

  };

  util.displayAlert = function (targetSelector, message, fadeOutSeconds) {
    alertSelector  = targetSelector + " .alert-custom";
    fadeOutSeconds = fadeOutSeconds || 5;
    message = "<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>" + message;

    if($(alertSelector).exists()) {
      $(alertSelector).html(message).show();
    } else {
      $(targetSelector).prepend("<div class='alert-custom text-danger'>" + message + "</div>");
    }
  };

  util.highlightElement = function(targetSelector, color, periodSeconds) {
    color         = color || '#FFC';
    periodSeconds = periodSeconds || 3;

    $(targetSelector).css("backgroundColor", color).stop().animate({
      backgroundColor: "#FFF"
    }, periodSeconds * 1000);
  };

  window.util = util;

})(window, $)