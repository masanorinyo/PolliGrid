define ['underscore'], (_)->
	($scope,$location,$stateParams,$timeout,Question,User,Filters,Error)->

		$scope.test = $stateParams.type+" "+$stateParams.id
		




		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


