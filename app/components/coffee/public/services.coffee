define ['angular'], (angular) ->
	angular.module('myapp.services', [])
		.factory 'filters', ()->
			target = [
				{
					title 			: "Age"
					question 		: "How old are you?"
					isFilterAdded 		: false
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
					isFilterAdded 		: false
					lists:[

						"Asian"
						"Hispanic"
						"Caucasian"
						"African-American"
					]
				}
			]

		.factory 'question', ()->
			question =[]
				
			