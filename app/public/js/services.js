(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.services', ['ngResource']).factory('Filters', function($resource) {
      return $resource("/api/filter/:offset", {
        offset: "@offset"
      }, {
        "save": {
          method: "POST",
          params: {
            offset: "0"
          }
        },
        "get": {
          method: "GET",
          isArray: true
        }
      });
    }).factory('FilterSearch', function($resource) {
      return $resource("/api/findByTerm/:searchTerm", {
        searchTerm: "@searchTerm"
      }, {
        "get": {
          method: "GET",
          isArray: true
        }
      });
    }).factory('Question', function($resource) {
      return $resource("/api/question", {}, {
        "save": {
          method: "POST"
        },
        "get": {
          method: "GET",
          isArray: true
        }
      });
    }).factory('User', function() {
      var user;
      return user = {
        _id: 1,
        name: 'Masanori',
        email: 'masanorinyo@gmail.com',
        password: 'test',
        profilePic: "/img/users/profile-pic.jpg",
        isLoggedIn: true,
        favorites: [],
        questionMade: [1],
        questionsAnswered: [],
        filterQuestionsAnswered: []
      };
    }).factory('Error', function() {
      var error;
      return error = {
        auth: ""
      };
    }).factory('Setting', function() {
      var page;
      return page = {
        isSetting: false,
        questionId: null,
        section: null
      };
    }).factory('Page', function() {
      var page;
      return page = {
        questionPage: 0,
        filterPage: 0
      };
    }).factory("Debounce", function($timeout, $q) {
      var debounce;
      return debounce = function(func, wait, immediate) {
        var deferred, timeout;
        timeout = void 0;
        deferred = $q.defer();
        return function() {
          var args, callNow, context, later;
          context = this;
          args = arguments;
          later = function() {
            timeout = null;
            if (!immediate) {
              deferred.resolve(func.apply(context, args));
              deferred = $q.defer();
            }
          };
          callNow = immediate && !timeout;
          if (timeout) {
            $timeout.cancel(timeout);
          }
          timeout = $timeout(later, wait);
          if (callNow) {
            deferred.resolve(func.apply(context, args));
            deferred = $q.defer();
          }
          return deferred.promise;
        };
      };
    });
  });

}).call(this);
