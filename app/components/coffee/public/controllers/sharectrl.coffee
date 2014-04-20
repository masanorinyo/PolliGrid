define [], ()->
	($scope,$modalInstance,$stateParams,$location,$timeout)->
		
		# if $stateParams.id.$http(get) -> false -> $location.path('/')

		$scope.closeModal = ()->
			$scope.$dismiss()
			$timeout ->
				$location.path('/')


		$scope.$apply()


