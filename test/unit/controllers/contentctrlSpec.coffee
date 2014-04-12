define(

	[
		'angular'
		'angularMocks'
		'app'
		'controllers/contentctrl'
	]

	(angular,mocks,app,ctrl)->
		describe 'ContentCtrl', ->
			
			$scope = null
			contentCtrl = null
			
			
			beforeEach ->
				angular.module("myapp.controllers")
					.controller('ContentCtrl', ctrl)
				
				mocks.module('myapp.controllers')
				mocks.inject(
					($rootScope,$controller)->
						$scope = $rootScope.$new()
						contentCtrl = $controller('ContentCtrl',{$scope:$scope})
				)

			it 'should say contentctrl', ->
				expect($scope.content).toEqual 'content'
			  

)