define ['underscore'], (_)->
	($scope,$modal,$stateParams,$location,$q,$timeout,Question)->
		

		# ------------- Scope Function ------------- #

		

		# --------------- controller for modal box --------------- #
		ChangePhotoCtrl = ($scope)->
			$scope.closeModal = ->
				$scope.$dismiss()



		$scope.openPhotoModal = ->
			console.log 'test'
			modalInstance = $modal.open(
				templateUrl:"views/modals/changePhotoModal.html"
				controller : ChangePhotoCtrl				
			)


		# -------------- Invoke Scope --------------#
		$scope.$apply()