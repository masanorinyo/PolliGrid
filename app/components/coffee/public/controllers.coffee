define ['angular'], (angular) ->
	angular.module('myapp.controllers', [])
		.controller 'MainCtrl', ($scope, $injector)->
			require(['controllers/mainctrl'], (mainctrl)->
				$injector.invoke(
					mainctrl, this,{"$scope": $scope}
				)
			)
			





