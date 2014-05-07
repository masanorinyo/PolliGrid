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
    });
  });

}).call(this);
