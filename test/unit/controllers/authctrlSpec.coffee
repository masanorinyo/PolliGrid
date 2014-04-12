define(

	[
		'angular'
		'angularMocks'
		'app'
		'controllers/authctrl'
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
					($rootScope,$controller)->
						$scope = $rootScope.$new()
						authCtrl = $controller('AuthCtrl',{$scope:$scope})
				)

			it 'should say auth', ->
				expect($scope.auth).toEqual 'auth'
			  

)