(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.services', []).factory('filters', function() {
      var target;
      return target = [
        {
          title: "Age",
          question: "How old are you?",
          lists: ["~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ "]
        }, {
          title: "Ethnicity",
          question: "What is your ethnicity?",
          lists: ["Asian", "Hispanic", "Caucasian", "African-American"]
        }
      ];
    }).factory('question', function() {
      var question;
      return question = [
        {
          id: '1',
          newOption: "",
          question: "Which one of the following best describes you",
          category: "lifestyle",
          favorite: true,
          numOfFilters: '2',
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
              title: "Age",
              question: "How old are you?",
              lists: ["~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ "]
            }, {
              title: "Ethnicity",
              question: "What is your ethnicity?",
              lists: ["Asian", "Hispanic", "Caucasian", "African-American"]
            }
          ]
        }
      ];
    });
  });

}).call(this);
