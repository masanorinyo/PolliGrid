define(

	[
		'angular'
		'angularMocks'
		'app'
		'controllers/mainctrl'
	]

	(angular,mocks,app,ctrl)->
		describe 'MainCtrl', ->
			
			$scope = null
			mainCtrl = null
			
			
			beforeEach ->
				angular.module("myapp.controllers")
					.controller('MainCtrl', ctrl)
				
				mocks.module('myapp.controllers')
				mocks.inject(
					($rootScope,$controller)->
						$scope = $rootScope.$new()
						mainCtrl = $controller('MainCtrl',{$scope:$scope})
				)

			it 'should say hello', ->
				expect($scope.hello).toEqual 'hello'
			  

)