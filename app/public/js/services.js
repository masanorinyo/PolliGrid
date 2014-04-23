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
        }, {
          id: 3,
          title: "Age",
          question: "How old are you?",
          created_at: 1398108212271,
          lists: ["~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ "]
        }, {
          id: 4,
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
          id: 1,
          newOption: "",
          question: "Which one of the following best describes you",
          category: "Lifestyle",
          respondents: [],
          alreadyAnswered: false,
          numOfFavorites: 0,
          numOfFilters: 3,
          totalResponses: 8,
          created_at: 1398108212271,
          creator: 1,
          options: [
            {
              title: 'positive',
              count: 4
            }, {
              title: 'negative',
              count: 4
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
            }, {
              id: 3,
              title: "Ethnicity",
              question: "What is your ethnicity?",
              lists: ["test", "dsa", "Caucasian", "African-American"]
            }, {
              id: 5,
              title: "Ethnicity",
              question: "What is your ethnicity?",
              lists: ["ds", "s", "d", "African-American"]
            }
          ]
        }, {
          id: 3,
          newOption: "",
          question: "Which one of the following best describes you",
          category: "Lifestyle",
          respondents: [],
          alreadyAnswered: false,
          numOfFavorites: 0,
          numOfFilters: 3,
          totalResponses: 8,
          created_at: 1398108212271,
          creator: 1,
          options: [
            {
              title: 'positive',
              count: 4
            }, {
              title: 'negative',
              count: 4
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
            }, {
              id: 9,
              title: "Ethnicity",
              question: "What is your ethnicity?",
              lists: ["test", "dsa", "Caucasian", "African-American"]
            }, {
              id: 5,
              title: "Ethnicity",
              question: "What is your ethnicity?",
              lists: ["ds", "s", "d", "African-American"]
            }, {
              id: 14,
              title: "Ethnicity",
              question: "What is your ethnicity?",
              lists: ["dhjg", "s", "d", "African-American"]
            }
          ]
        }
      ];
    }).factory('User', function() {
      var user;
      return user = {
        id: 1,
        name: 'Masanori',
        email: 'masanorinyo@gmail.com',
        password: 'test',
        profilePic: "/img/profile-pic.jpg",
        isLoggedIn: false,
        favorites: [1],
        questionMade: [1],
        questionsAnswered: [
          {
            'id': 1,
            'answer': "positive"
          }
        ],
        filterQuestionsAnswered: [
          {
            'id': 2,
            'answer': 'Asian'
          }
        ]
      };
    });
  });

}).call(this);
