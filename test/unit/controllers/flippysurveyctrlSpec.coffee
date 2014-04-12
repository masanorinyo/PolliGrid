define(

	[
		'angular'
		'angularMocks'
		'app'
		'controllers'
	]

	(angular,mocks,app,ctrl)->
		describe 'AuthCtrl', ->
			
			$scope = null
			authCtrl = null
			
			
			beforeEach ->
				
				mocks.module('myapp.controllers')
				mocks.inject(
					($rootScope,$controller)->
						$scope = $rootScope.$new()
						flippysurveyCtrl = $controller('FlippySurveyCtrl',{$scope:$scope})
				)

			it 'should say Flippy Survey', ->
				expect($scope.flippysurvey).toEqual 'flippysurvey'
			  

)