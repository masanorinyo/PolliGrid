define(

	[
		'angular'
		'angularMocks'
		'app'
		'controllers/loginctrl'
	]

	(angular,mocks,app,ctrl)->
		describe 'AuthCtrl', ->
			
			$scope = null
			authCtrl = null
			
			
			beforeEach ->
				angular.module("myapp.controllers")
					.controller('AuthCtrl', ctrl)
				
				mocks.module('myapp.controllers')
				mocks.inject(
					($rootScope,$controller,$location,$modalInstance,$timeout)->
						$scope = $rootScope.$new()
						authCtrl = $controller 'AuthCtrl',{
								$scope 			: $scope
								$location 		: $location
								$modalInstance 	: $modalInstance
								$timeout 		: $timeout
							}
						
				)

			it 'should say login', ->
				expect($scope.title).toEqual 'Login'

			
			  

)