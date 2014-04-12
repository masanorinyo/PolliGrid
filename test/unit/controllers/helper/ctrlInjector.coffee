injectCtrl = (ctrlName, ctrlVariable, ctrlSource)->

	angular.module("myapp.controllers")
		.controller(ctrlName, ctrlSource)

	mocks.module('myapp.controllers')
	mocks.inject(
		($rootScope,$controller)->
			$scope = $rootScope.$new()
			ctrlVariable = $controller(ctrlName,{$scope:$scope})
	)


module.exports = injectCtrl
