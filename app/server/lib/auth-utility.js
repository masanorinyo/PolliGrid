(function() {
  exports.rememberOauth = function(req, res) {
    req.session.cookie.maxAge = 60000 * 60 * 24 * 365;
  };

  exports.rememberMe = function(req, res) {
    if (req.body.remember_me) {
      return req.session.cookie.maxAge = 60000 * 60 * 24 * 365;
    } else {
      return req.session.cookie.expires = false;
    }
  };

  exports.isLoggedIn = function(req, res, next) {
    if (req.isAuthenticated()) {
      return next();
    } else {
      return res.redirect("/");
    }
  };

  exports.isInvited = function(req, res) {
    var isInvited;
    return isInvited = false;
  };

  exports.cleanup = function(req, res) {
    return req.session.message = "";
  };

}).call(this);
