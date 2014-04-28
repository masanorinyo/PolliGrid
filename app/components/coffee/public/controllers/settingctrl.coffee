define ['underscore'], (_)->
	($scope,$location,$modal,$stateParams,$timeout,Question,User,Filters,Error)->

		$scope.type = $stateParams.type
		$scope.id = $stateParams.id
		$scope.user = User
		


		# --------------- controller for modal box --------------- #
		ChangePassCtrl = ($scope)->
			$scope.closeModal = ->
				$scope.$dismiss()

		ChangePhotoCtrl = ($scope)->
			$scope.closeModal = ->
				$scope.$dismiss()



		# --------------- Setting Content navi --------------- #

		$scope.showFavorites = ->
			$scope.type = "favorites"
			$location.path('setting/'+$scope.id+"/favorites")

			

		$scope.showQuestions = ->
			$scope.type = "questions"
			$location.path('setting/'+$scope.id+"/questions")

		$scope.showAnswers = ->
			$scope.type = "answers"
			$location.path('setting/'+$scope.id+"/answers")

		$scope.showFilters = ->
			$scope.type = "filters"
			$location.path('setting/'+$scope.id+"/filters")





		# ----------- modal handler --------------#

		$scope.openPassModal = ->

			modalInstance = $modal.open(			
				templateUrl: "views/modals/changePassModal.html"
				controller : ChangePassCtrl
			)


		$scope.openPhotoModal = ->
			modalInstance = $modal.open(
				templateUrl:"views/modals/changePhotoModal.html"
				controller : ChangePhotoCtrl				
			)

		


		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


