(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.services', []).factory('Filters', function() {
      var target;
      return target = [
        {
          id: 1,
          title: "Age",
          question: "How old are you?",
          created_at: 1398108212271,
          lists: ["~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ "]
        }, {
          id: 2,
          title: "Ethnicity",
          question: "What is your ethnicity?",
          created_at: 1398108312271,
          lists: ["Asian", "Hispanic", "Caucasian", "African-American"]
        }
      ];
    }).factory('Question', function() {
      var question;
      return question = [
        {
          id: '1',
          newOption: "",
          question: "Which one of the following best describes you",
          category: "Lifestyle",
          respondents: [],
          favorite: false,
          favoritedBy: [],
          numOfFavorites: 0,
          numOfFilters: '2',
          totalResponses: 0,
          created_at: 1398108212271,
          options: [
            {
              title: 'positive',
              count: 0
            }, {
              title: 'negative',
              count: 0
            }
          ],
          targets: [
            {
              id: 1,
              title: "Age",
              question: "How old are you?",
              lists: ["~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ "]
            }, {
              id: 2,
              title: "Ethnicity",
              question: "What is your ethnicity?",
              lists: ["Asian", "Hispanic", "Caucasian", "African-American"]
            }
          ]
        }
      ];
    }).factory('User', function() {
      var user;
      return user = {
        id: '1',
        name: 'Masanori',
        email: 'masanorinyo@gmail.com',
        password: 'test',
        profilePic: "/img/profile-pic.jpg",
        isLoggedIn: false,
        favorites: [],
        questionsAnswered: [],
        filterQuestionsAnswered: []
      };
    });
  });

}).call(this);
