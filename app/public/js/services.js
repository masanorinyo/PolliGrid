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
      return $resource("/api/question/:questionId/:action", {
        questionId: "@questionId",
        action: "@action"
      }, {
        "get": {
          method: "GET",
          params: {
            action: 0
          }
        },
        "save": {
          method: "POST",
          params: {
            questionId: 0,
            action: 0
          }
        },
        "favorite": {
          method: "PUT"
        }
      });
    }).factory('UpdateQuestion', function($resource) {
      return $resource("/api/updateQuestion/:questionId/:userId/:visitorId/:title/:filterId/:index/:task", {
        questionId: "@questionId",
        userId: "@userId",
        visitorId: "@visitorId",
        title: "@title",
        filterId: "@filterId",
        index: "@index"
      }, {
        "updateQuestion": {
          method: "PUT",
          params: {
            visitorId: 0,
            task: "update"
          }
        },
        "updateFilters": {
          method: "PUT",
          params: {
            visitorId: 0,
            task: "update"
          }
        },
        "removeAnswer": {
          method: "PUT",
          params: {
            task: "remove"
          }
        }
      });
    }).factory('QuestionTypeHead', function($resource) {
      return $resource("/api/getQuestionTitle/:term/:category", {
        term: "@term",
        category: "@category"
      }, {
        "get": {
          method: "GET",
          isArray: true
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
    }).factory('UpdateUserInfo', function($resource) {
      return $resource("/api/updateUser/:userId/:qId/:qAnswer/:fId/:fAnswer/:task", {
        userId: "@userId",
        qId: "@questionId",
        qAnswer: "@questionAnswer",
        fId: "@filterId",
        fAnswer: "@filterAnswer",
        task: "@task"
      }, {
        "answerQuestion": {
          method: "PUT",
          params: {
            task: "updateQuestion",
            fId: 0,
            fAnswer: 0
          }
        },
        "answerFilter": {
          method: "PUT",
          params: {
            task: "updateFilter",
            qId: 0,
            qAnswer: 0
          }
        },
        "favorite": {
          method: "PUT",
          params: {
            qAnswer: 0,
            fId: 0,
            fAnswer: 0
          }
        },
        "reset": {
          method: "PUT",
          params: {
            qAnswer: 0,
            fId: 0,
            fAnswer: 0,
            task: "reset"
          }
        }
      });
    }).factory('User', function(ipCookie, $http) {
      var loggedInUser, randLetter, uniqid, user;
      randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
      uniqid = randLetter + Date.now();
      loggedInUser = ipCookie("loggedInUser");
      if (loggedInUser) {
        $http({
          url: "/api/getUser",
          method: "GET",
          params: {
            userId: loggedInUser._id
          }
        }).success(function(data) {
          data.isLoggedIn = true;
          loggedInUser = data;
          return user.user = data;
        });
      }
      return user = {
        visitor: {
          _id: uniqid,
          name: 'visitor',
          favorites: [],
          isLoggedIn: false,
          questionsAnswered: [],
          filterQuestionsAnswered: []
        },
        user: loggedInUser
      };
    }).factory('Verification', function($resource) {
      return $resource("/api/user/:id", {
        id: "@id"
      }, {
        "findUser": {
          method: "GET"
        }
      });
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
        category: "All"
      };
    }).factory('NewQuestion', function() {
      var question;
      return question = {
        question: ""
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
