define ['angular','services'], (angular) ->
	angular.module('myapp.controllers', ['myapp.services'])

		.controller 'MainCtrl', ($scope,$injector,$location,$stateParams,$timeout,$state,$q)->
			require(['controllers/mainctrl'], (mainctrl)->
				$injector.invoke(
					mainctrl, this,{
						"$scope" 				: $scope
						"$location" 	 		: $location
						"$stateParams" 			: $stateParams
						"$timeout" 				: $timeout
						"$q" 					: $q
					}
				)
			)
			

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
		
		.controller 'AuthCtrl', ($rootScope,$scope, $injector,$modalInstance,$location,$timeout,$http,ipCookie)->
			require(['controllers/authctrl'], (authctrl)->
				$injector.invoke(
					authctrl, this,{
						"$rootScope" 			: $rootScope
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$http" 				: $http
						"ipCookie" 				: ipCookie
					}
				)
			)

		.controller 'CreateCtrl', ($scope, $injector,$modalInstance,$location,$timeout,$state,$stateParams,$q)->
			require(['controllers/createctrl'], (createctrl)->
				$injector.invoke(
					createctrl, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$state" 				: $state
						"$stateParams" 			: $stateParams
						"$q"					: $q

						
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

		.controller 'NewFilterCtrl', ($scope,$injector,$timeout,$q)->
			require(['controllers/newfilterctrl'], (newfilterctrl)->
				$injector.invoke(
					newfilterctrl, this,{
						"$scope" 				: $scope
						"$timeout" 				: $timeout
						"$q" 					: $q
					}
				)
			)

		.controller 'ContentCtrl', ($scope, $injector,$stateParams,$timeout,$state,$q)->
			require(['controllers/contentctrl'], (contentctrl)->
				$injector.invoke(
					contentctrl, this,{
						"$scope": $scope
						"$stateParams":$stateParams
						"$timeout":$timeout
						"$state":$state
						"$q"	:$q
					}
				)
			)

		.controller 'ListCtrl', ($scope, $q, $location,$injector)->
			require(['controllers/listctrl'], (listctrl)->
				$injector.invoke(
					listctrl, this,{
						"$scope" 				: $scope
						"$q" 					: $q
						"$location" 	 		: $location
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

		.controller 'DeepResultCtrl', ($scope, $injector,$modalInstance,$location,$timeout,$q,$state)->
			require(['controllers/deepresult'], (deepresult)->
				$injector.invoke(
					deepresult, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$q" 					: $q
						"$state" 				: $state
					}
				)
			)

		.controller 'SettingCtrl', ($scope,$modal, $injector,$location,$timeout,$q)->
			require(['controllers/settingctrl'], (settingctrl)->
				$injector.invoke(
					settingctrl, this,{
						"$scope" 				: $scope
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$q" 					: $q
						"$modal" 				: $modal
					}
				)
			)

		.controller 'ChangePassCtrl', ($scope, $injector,$modal,$location,$timeout,$q)->
			require(['controllers/changepassctrl'], (changepassctrl)->
				$injector.invoke(
					changepassctrl, this,{
						"$scope" 				: $scope
						"$modal"		 		: $modal
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$q" 					: $q
					}
				)
			)
		.controller 'ChangePhotoCtrl', ($scope, $injector,$modal,$location,$timeout,$q)->
			require(['controllers/changephotoctrl'], (changephotoctrl)->
				$injector.invoke(
					changephotoctrl, this,{
						"$scope" 				: $scope
						"$modal"		 		: $modal
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$q" 					: $q
					}
				)
			)
		.controller 'FilterListCtrl', ($scope, $injector,$location,$timeout,$q)->
			require(['controllers/filterlistctrl'], (filterlistctrl)->
				$injector.invoke(
					filterlistctrl, this,{
						"$scope" 				: $scope
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$q" 					: $q
					}
				)
			)
		.controller 'TargetListCtrl', ($scope, $injector,$location,$timeout,$q)->
			require(['controllers/targetlistctrl'], (targetlistctrl)->
				$injector.invoke(
					targetlistctrl, this,{
						"$scope" 				: $scope
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$q" 					: $q
					}
				)
			)