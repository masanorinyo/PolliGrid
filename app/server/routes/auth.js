(function() {
  var User, auth_utility;

  User = require("../models/user");

  auth_utility = require("../lib/auth-utility");

  module.exports = function(app, passport) {
    app.post("/api/login", passport.authenticate("local-login"), function(req, res, next) {
      if (req.user) {
        auth_utility.rememberMe(req, res, next);
        return res.send(req.user);
      } else {
        return res.send(req.session.message);
      }
    });
    app.post("/api/signup", passport.authenticate("local-signup"), function(req, res, next) {
      if (req.user) {
        auth_utility.rememberMe(req, res, next);
        return res.send(req.user);
      } else {
        return res.send(req.session.message);
      }
    });
    app.get("/api/logout", function(req, res) {
      req.logout();
      return req.session.cookie.expires = false;
    });
    return app["delete"]("/api/delete", function(req, res) {
      if (req.user) {
        return User.remove(function(err, user) {
          req.session.destroy(function() {
            return req.logout();
          });
          if (err) {
            throw err;
          } else {
            return User.findById(req.user.id, function(err, user) {
              return res.redirect("/");
            });
          }
        });
      } else {
        return res.redirect("/");
      }
    });
  };

}).call(this);
