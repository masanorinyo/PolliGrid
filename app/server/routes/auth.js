(function() {
  var User, auth_utility, escapeChar;

  User = require("../models/user");

  auth_utility = require("../lib/auth-utility");

  escapeChar = function(regex) {
    return regex.replace(/([()[{*+.$^\\|?])/g, '\\$1');
  };

  module.exports = function(app, passport) {
    app.post("/api/auth/login", passport.authenticate("local-login"), function(req, res, next) {
      if (req.user) {
        return res.send(req.user);
      } else {
        return res.send(req.session.message);
      }
    });
    app.post("/api/auth/signup", passport.authenticate("local-signup"), function(req, res, next) {
      if (req.user) {
        return res.send(req.user);
      } else {
        return res.send(req.session.message);
      }
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
    return app.get("/api/user/:id/:email", function(req, res) {
      var email, id;
      console.log(id = escapeChar(unescape(req.params.id)));
      console.log(email = unescape(req.params.email));
      if (id !== "0") {
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
      } else {
        return User.find({
          "local.email": email
        }, function(err, user) {
          if (err) {
            return res.send(err);
          } else {
            console.log(user);
            return res.send(user);
          }
        });
      }
    });
  };

}).call(this);
