define [], ()->
	($scope,$modalInstance,$stateParams,$location,$timeout,Setting)->
		


		# (issue)  check if this is necessary
		if Setting.questionId
			$scope.questionId = Setting.questionId
		else 
			$scope.questionId = $stateParams.id
		
		link = window.location.origin
		
		$scope.sharableLink = link.concat("/#/question/",$scope.questionId)

		$scope.closeModal = ()->
			$scope.$dismiss()

			if Setting.isSetting

				# cleans out the quesiton id
				Setting.questionId = ""	
				$timeout ->
					$location.path(Setting.section)
				,100,true
			else 
				$timeout ->
					$location.path('/')
				,100,true


		$scope.$apply()


