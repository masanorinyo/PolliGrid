define ['underscore'], (_)->
	(
		$scope
		$modal
		$stateParams
		$location
		$q
		$timeout
		Question
		User
		Verification
		Passwowrd
		$http
	)->
		

		# ------------- Scope Function ------------- #

		

		# --------------- controller for modal box --------------- #
		ChangePassCtrl = ($scope)->
			
			$scope.rightOldPass = false
			$scope.conditions = 
				length : false
				same : false
			$scope.warning = 
				oldPass : ''
				compare : ''
				length	: ''
			$scope.newPass = ''
			$scope.confirm = ''

			$scope.closeModal = ->
				$scope.$dismiss()
			

			$scope.checkOldPass = (oldPass)->
				$scope.rightOldPass = false
				Verification.checkPass(
					email:escape(User.user.local.email)
					pass:escape(oldPass)
				).$promise.then (data)->
					console.log data
					if data[0] == "t"
						console.log 'test'
						$scope.rightOldPass = true
						$scope.warning.oldPass = ''
					else 
						$scope.rightOldPass = false
						$scope.warning.oldPass = "Wrong password"

			$scope.comparePass = (newPass,confirm)->
				
				console.log newPass
				console.log confirm
				$scope.conditions.same = false
				$scope.conditions.length = false
				

				if newPass == confirm 
				
					$scope.conditions.same = true
					$scope.warning.compare = ''
				
				else 
					
					$scope.warning.compare = 'Please type the same passwords'
					$scope.rightNewPass = false

				if confirm.length > 6
					
					$scope.conditions.length = true
					$scope.warning.length = ""
				
				else

					$scope.conditions.length = false
					$scope.warning.length = "Please type more than 6 characteres"
				
				if $scope.conditions.length and $scope.conditions.same and $scope.rightOldPass
					Passwowrd.reset(
						email:escape(User.user.local.email)
						pass:escape(confirm)
					).$promise.then (data)->
						console.log data
						$scope.$dismiss()





		$scope.openPassModal = ->
			
			modalInstance = $modal.open(			
				templateUrl: "views/modals/changePassModal.html"
				controller: ChangePassCtrl
			)
			


		# -------------- Invoke Scope --------------#
		$scope.$apply()