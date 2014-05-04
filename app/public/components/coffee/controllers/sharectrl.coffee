define [], ()->
	($scope,$modalInstance,$stateParams,$location,$timeout,Setting)->
		
		# if $stateParams.id.$http(get) -> false -> $location.path('/')


		$scope.questionId = Setting.questionId
		console.log $scope.questionId

		$scope.closeModal = ()->
			$scope.$dismiss()

			if Setting.isSetting
				
				$timeout ->
					$location.path(Setting.section)
				,100,true
			else 
				$timeout ->
					$location.path('/')
				,100,true


		$scope.$apply()


