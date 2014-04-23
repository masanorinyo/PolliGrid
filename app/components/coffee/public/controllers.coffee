define ['angular','services'], (angular) ->
	angular.module('myapp.controllers', ['myapp.services'])
		
		.controller 'WhichOneCtrl', ($scope,User)->
			$scope.searchQuestion = ''

			$scope.user = User

			$scope.searchByCategory = (category)->

				$scope.searchQuestion = category



		.controller 'ShareCtrl', ($scope, $injector,$modalInstance,$location,$timeout)->
			require(['controllers/sharectrl'], (sharectrl)->
				$injector.invoke(
					sharectrl, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
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

		.controller 'CreateCtrl', ($scope, $injector,$modalInstance,$location,$timeout)->
			require(['controllers/createctrl'], (createctrl)->
				$injector.invoke(
					createctrl, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						
					}
				)
			)

		.controller 'FilterCtrl', ($scope, $injector,$timeout)->
			require(['controllers/filterctrl'], (filterctrl)->
				$injector.invoke(
					filterctrl, this,{
						"$scope" 				: $scope
						"$timeout" 				: $timeout
						
					}
				)
			)

		.controller 'NewFilterCtrl', ($scope,$injector,$timeout)->
			require(['controllers/newfilterctrl'], (newfilterctrl)->
				$injector.invoke(
					newfilterctrl, this,{
						"$scope" 				: $scope
						"$timeout" 				: $timeout
					}
				)
			)

		.controller 'ContentCtrl', ($scope, $injector)->
			require(['controllers/contentctrl'], (contentctrl)->
				$injector.invoke(
					contentctrl, this,{"$scope": $scope}
				)
			)

		.controller 'ListCtrl', ($scope, $q,$injector)->
			require(['controllers/listctrl'], (listctrl)->
				$injector.invoke(
					listctrl, this,{
						"$scope": $scope
						"$q" 	: $q
					}
				)
			)

		.controller 'TargetAudienceCtrl', ($scope, $timeout,$q, $injector)->
			require(['controllers/targetaudiencectrl'], (targetaudiencectrl)->
				$injector.invoke(
					targetaudiencectrl, this,{
						"$scope": $scope
						"$timeout":$timeout
						"$q":$q
					}
				)
			)