(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.services', ['ngResource']).factory('Filters', function($resource) {
      return $resource("/api/filter/:searchTerm/:offset", {
        offset: "@offset",
        searchTerm: "@searchTerm"
      }, {
        "save": {
          method: "POST",
          params: {
            offset: "0",
            searchTerm: "new"
          }
        },
        "get": {
          method: "GET",
          isArray: true
        }
      });
    }).factory('FilterTypeHead', function($resource) {
      return $resource("/api/getFilterTitle/:term", {
        term: "@term"
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
        }
      });
    }).factory('FindQuestions', function($resource) {
      return $resource("/api/findQuestions/:searchTerm/:category/:order/:offset", {
        searchTerm: "@searchTerm",
        category: "@category",
        order: "@order",
        offset: "@offset"
      }, {
        "get": {
          method: "GET",
          isArray: true
        },
        "default": {
          method: "GET",
          params: {
            searchTerm: "All",
            category: "All",
            order: "Recent",
            offset: 0
          },
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
    }).factory('Search', function() {
      var search;
      return search = {
        searchWord: "",
        category: "All"
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
