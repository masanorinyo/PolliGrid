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
          alreadyAnswered: false,
          favoritedBy: [],
          numOfFavorites: 0,
          numOfFilters: '2',
          totalResponses: 0,
          created_at: 1398108212271,
          options: [
            {
              title: 'test1',
              count: 0
            }, {
              title: 'test 2',
              count: 0
            }, {
              title: 'test 3',
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
        }, {
          id: '2',
          newOption: "",
          question: "Which one of the following best describes you",
          category: "Lifestyle",
          respondents: [],
          favorite: false,
          alreadyAnswered: true,
          favoritedBy: [1],
          numOfFavorites: 0,
          numOfFilters: '2',
          totalResponses: 1,
          created_at: 1398108212271,
          options: [
            {
              title: 'positive',
              count: 1
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
        favorites: [1],
        questionsAnswered: [
          {
            'id': 2,
            'answer': "positive"
          }
        ],
        filterQuestionsAnswered: [
          {
            'id': 1,
            'answer': '11 ~ 20'
          }, {
            'id': 2,
            'answer': 'Asian'
          }
        ]
      };
    });
  });

}).call(this);
