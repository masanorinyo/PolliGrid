define ['angular','services'], (angular) ->
	angular.module('myapp.controllers', ['myapp.services'])
		
		.controller 'WhichOneCtrl', ($sce,$scope,$location,$stateParams,$timeout,$state,User)->
			$scope.searchQuestion = ''
			$scope.user = User

			$scope.refresh = ()->
				
				$location.path('/')
				
				$timeout ->
					# reload the page
					$state.transitionTo($state.current, $stateParams, {
						reload: true
						inherit: false
						notify: true
					})

				,100,true

			


			$scope.logout = ()->
				
				
				
				User.id  					 = 0
				User.name  					 = ''
				User.email 					 = ''
				User.password 				 = ''
				User.profilePic 			 = ""
				User.isLoggedIn 			 = false
				User.favorites 				 = []
				User.questionMade 			 = []
				User.questionsAnswered 		 = []
				User.filterQuestionsAnswered = []

				$location.path('/')
				
				$timeout ->
					
					# reload the page
					$state.transitionTo($state.current, $stateParams, {
						reload: true
						inherit: false
						notify: true
					})

				,100,true


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

		.controller 'CreateCtrl', ($scope, $injector,$modalInstance,$location,$timeout,$state,$stateParams)->
			require(['controllers/createctrl'], (createctrl)->
				$injector.invoke(
					createctrl, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$state" 				: $state
						"$stateParams" 				: $stateParams

						
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

		.controller 'ContentCtrl', ($scope, $injector,$stateParams,$timeout,$state)->
			require(['controllers/contentctrl'], (contentctrl)->
				$injector.invoke(
					contentctrl, this,{
						"$scope": $scope
						"$stateParams":$stateParams
						"$timeout":$timeout
						"$state":$state
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

		.controller 'DeepResultCtrl', ($scope, $injector,$modalInstance,$location,$timeout,$q)->
			require(['controllers/deepresult'], (deepresult)->
				$injector.invoke(
					deepresult, this,{
						"$scope" 				: $scope
						"$modalInstance" 		: $modalInstance
						"$location" 	 		: $location
						"$timeout" 				: $timeout
						"$q" 					: $q
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