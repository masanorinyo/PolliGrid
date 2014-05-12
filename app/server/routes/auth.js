(function() {
  var User, auth_utility;

  User = require("../models/user");

  auth_utility = require("../lib/auth-utility");

  module.exports = function(app, passport) {
    app.post("/api/auth/login", passport.authenticate("local-login"), function(req, res, next) {
      console.log(req.body);
      if (req.user) {
        auth_utility.rememberMe(req, res, next);
        return res.send(req.user);
      } else {
        return res.send(req.session.message);
      }
    });
    app.post("/api/auth/signup", passport.authenticate("local-signup"), function(req, res, next) {
      if (req.user) {
        auth_utility.rememberMe(req, res, next);
        return res.send(req.user);
      } else {
        return res.send(req.session.message);
      }
    });
    app.get("/api/auth/logout", function(req, res) {
      req.logout();
      return req.session.cookie.expires = false;
    });
    app["delete"]("/api/auth/delete", function(req, res) {
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
    return app.get("/api/user/:id", function(req, res) {
      var id;
      id = req.params.id;
      return User.findById(id, function(err, user) {
        if (err) {
          return res.send("foundUser", {
            foundUser: false
          });
        } else if (user) {
          return res.send("foundUser", {
            foundUser: true
          });
        } else {
          return res.send("foundUser", {
            foundUser: false
          });
        }
      });
    });
  };

}).call(this);
