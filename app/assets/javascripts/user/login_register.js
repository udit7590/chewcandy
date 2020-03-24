var LoginRegister = (function() {

  function LoginRegister(loginContainer, regsiterContainer) {
    this.$loginContainer = loginContainer;
    this.$regsiterContainer = regsiterContainer;

    this.initialize();
    this.bindEvents();
  }

  LoginRegister.prototype.initialize = function() {
    $('.modal').on('hidden.bs.modal', function (e) {
      var $this = $(this);

      $this.find('form').trigger('reset');
      $this.find('.alert.alert-error').remove();
    });
    LoginRegister.showLoginIfLoginURL();
  };

  LoginRegister.showLoginIfLoginURL = function() {
    if(window.location.hash.substring(1) == 'login' || window.location.pathname == '/login') {
      $('#loginModal').modal('show');
    }
  }

  LoginRegister.prototype.bindEvents = function() {
    var _this = this;

    //For disabling submit buttons on submit
    this.$loginContainer.find('form').on('submit', function() {
      disableSubmitButtonOnSubmit(_this.$loginContainer);
    });
    this.$regsiterContainer.find('form').on('submit', function() {
      disableSubmitButtonOnSubmit(_this.$regsiterContainer)
    });

    //For switching between login and register window
    this.$loginContainer.find('.switchable').click(function() {
      _this.$loginContainer.modal('hide');
      _this.$regsiterContainer.modal('show');
    });
    this.$regsiterContainer.find('.switchable').click(function() {
      _this.$regsiterContainer.modal('hide');
      _this.$loginContainer.modal('show');
    });
  };

  // Section for class functions
  // --------------------------------
  LoginRegister.switchWindow = function(window1, window2) {
    $('#' + window1).modal('hide');
    $('#' + window2).modal('show');
  };

  // Section for private functions
  // --------------------------------
  function disableSubmitButtonOnSubmit($container) {
    $container.find('input[type=submit]').attr("disabled", true);
    $container.find('input[type=submit]').attr('value', "Please wait...");
  }

  //Return the class
  return LoginRegister;

})();

$(function() {
  var loginRegister = new LoginRegister($('#loginModal'), $('#registrationModal'));
});

