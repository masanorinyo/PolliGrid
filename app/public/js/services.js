(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.services', ['ngResource']).factory('Filters', function($resource) {
      return $resource("/api/filter", {
        id: "@id"
      }, {
        "save": {
          method: "POST"
        },
        "get": {
          method: "GET"
        },
        "query": {
          method: "GET",
          isArray: true
        }
      });
    }).factory('Question', function($resource) {
      return $resource("/api/question", {
        id: "@id"
      }, {
        "save": {
          method: "POST"
        },
        "get": {
          method: "GET",
          isArray: true
        },
        "query": {
          'method': "GET",
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
    });
  });

}).call(this);
