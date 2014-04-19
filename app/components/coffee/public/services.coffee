define ['angular'], (angular) ->
	angular.module('myapp.services', [])
		.factory 'filters', ()->
			target = [
				{
					title 			: "Age"
					question 		: "How old are you?"
					lists:[

						"~ 10"
						"11 ~ 20"
						"21 ~ 30"
						"31 ~ 40"
						"41 ~ 50"
						"51 ~ 60"
						"61 ~ "
					]
				}
				{
					title: "Ethnicity"
					question: "What is your ethnicity?"
					lists:[

						"Asian"
						"Hispanic"
						"Caucasian"
						"African-American"
					]
				}
			]

		.factory 'question', ()->
			question = [
				newOption 			: ""
				question 			: "of the following best describes you"
				category 			: "lifestyle"
				options 			: ['positive','negative']
				targets 			: []
			]
				
				
			