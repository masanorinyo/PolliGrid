(function() {
  define(['angular', 'app'], function(angular, app) {
    return app.config(function($routeProvider) {
      return $routeProvider.when('/', {
        templateUrl: "partials/main.html",
        controller: "MainCtrl"
      });
    });
  });

}).call(this);
