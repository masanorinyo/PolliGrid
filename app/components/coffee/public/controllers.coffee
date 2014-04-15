define ['angular'], (angular) ->
	angular.module('myapp.controllers', [])
		
		.controller 'WhichOneCtrl', ($scope)->
			$scope.flippysurvey = 'flippysurvey'


		.controller 'AuthCtrl', ($scope, $injector,$modalInstance,$location,$timeout)->
			require(['controllers/authctrl'], (authctrl)->
				$injector.invoke(
					authctrl, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
					}
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