define ['angular','services'], (angular) ->
	angular.module('myapp.controllers', ['myapp.services'])
		
		.controller 'WhichOneCtrl', ($scope)->
			$scope.whichone = 'whichone'

		.controller 'UtilityCtrl', ($scope,$injector)->
			require(['controllers/utilityctrl'], (utilityctrl)->
				$injector.invoke(
					utilityctrl, this,{
						"$scope" 				: $scope
					}
				)
			)
		
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

		.controller 'CreateCtrl', ($scope, $injector,$modalInstance,$location,$timeout,filters)->
			require(['controllers/createctrl'], (createctrl)->
				$injector.invoke(
					createctrl, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"filters" 				: filters
					}
				)
			)

		.controller 'NewFilterCtrl', ($scope,$injector,$timeout,filters)->
			require(['controllers/newfilterctrl'], (newfilterctrl)->
				$injector.invoke(
					newfilterctrl, this,{
						"$scope" 				: $scope
						"$timeout" 				: $timeout
						"filters" 				: filters
					}
				)
			)

		.controller 'ContentCtrl', ($scope, $injector)->
			require(['controllers/contentctrl'], (contentctrl)->
				$injector.invoke(
					contentctrl, this,{"$scope": $scope}
				)
			)