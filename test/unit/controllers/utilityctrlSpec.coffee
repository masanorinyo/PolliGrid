define(

	[
		'angular'
		'angularMocks'
		'app'
		'controllers/utilityctrl'
	]

	(angular,mocks,app,ctrl)->
		
		describe 'UtilityCtrl', ->
			
			$scope = null
			utilityCtrl = null
			
			
			beforeEach ->
				angular.module("myapp.controllers")
					.controller('UtilityCtrl', ctrl)
				
				mocks.module('myapp.controllers')
				mocks.inject(
					($rootScope,$controller)->
						$scope = $rootScope.$new()
						utilityCtrl = $controller('UtilityCtrl',{$scope:$scope})
				)
				

			# it 'should say utility', ->
			# 	expect($scope.utility).toEqual 'utility'
			  

)