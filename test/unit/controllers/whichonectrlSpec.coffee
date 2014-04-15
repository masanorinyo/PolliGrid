define(

	[
		'angular'
		'angularMocks'
		'app'
		'controllers'
	]

	(angular,mocks,app,ctrl)->
		describe 'WhichOneCtrl', ->
			
			$scope = null
			whichoneCtrl = null
			
			
			beforeEach ->
				
				mocks.module('myapp.controllers')
				mocks.inject(
					($rootScope,$controller)->
						$scope = $rootScope.$new()
						whichoneCtrl = $controller('WhichOneCtrl',{$scope:$scope})
				)

			# it 'should say Flippy Survey', ->
			# 	expect($scope.whichoneCtrl).toEqual 'whichoneCtrl'
			  

)