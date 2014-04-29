define ['underscore'], (_)->
	($scope,$modal,$stateParams,$location,$q,$timeout,Question)->
		

		# ------------- Scope Function ------------- #

		

		# --------------- controller for modal box --------------- #
		ChangePassCtrl = ($scope)->
			$scope.closeModal = ->
				$scope.$dismiss()






		$scope.openPassModal = ->

			modalInstance = $modal.open(			
				templateUrl: "views/modals/changePassModal.html"
				controller: ChangePassCtrl
			)

		# -------------- Invoke Scope --------------#
		$scope.$apply()