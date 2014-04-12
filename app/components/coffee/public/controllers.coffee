define ['angular'], (angular) ->
	angular.module('myapp.controllers', [])
		
		.controller 'FlippySurveyCtrl', ($scope)->
			$scope.flippysurvey = 'flippysurvey'


		.controller 'AuthCtrl', ($scope, $injector)->
			require(['controllers/authctrl'], (authctrl)->
				$injector.invoke(
					authctrl, this,{"$scope": $scope}
				)
			)
			
		.controller 'UtilityCtrl', ($scope, $injector)->
			require(['controllers/utilityctrl'], (utilityctrl)->
				$injector.invoke(
					utilityctrl, this,{"$scope": $scope}
				)
			)

		.controller 'ContentCtrl', ($scope, $injector)->
			require(['controllers/contentctrl'], (contentctrl)->
				$injector.invoke(
					contentctrl, this,{"$scope": $scope}
				)
			)