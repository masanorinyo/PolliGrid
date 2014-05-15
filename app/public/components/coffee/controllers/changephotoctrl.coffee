define ['underscore'], (_)->
	(
		$scope
		$modal
		$stateParams
		$location
		$q
		$timeout
		$upload
		Question
		User
	)->
		

		# ------------- Scope Function ------------- #

		

		# --------------- controller for modal box --------------- #
		ChangePhotoCtrl = ($scope)->
			$scope.closeModal = ->
				$scope.$dismiss()

			console.log $scope.fileData = {name:User.user.username}

			$scope.onFileSelect = ($files) ->

				console.log 'test'
				i = 0
				console.log $files
				while i < $files.length
					
					console.log $file = $files[i]
					
					$scope.upload = $upload.upload(
						url: "/api/uploadPhoto"
						method:"POST"
						data:{fileData:$scope.fileData}
						file: $file
						

					).progress((evt) ->
						console.log "percent: " + parseInt(100.0 * evt.loaded / evt.total)
						return
					).success((data, status, headers, config) ->
						console.log data
						return
					)
					i++
				return


		

		$scope.openPhotoModal = ->
			
			modalInstance = $modal.open(
				templateUrl:"views/modals/changePhotoModal.html"
				controller : ChangePhotoCtrl				
			)


		# -------------- Invoke Scope --------------#
		$scope.$apply()