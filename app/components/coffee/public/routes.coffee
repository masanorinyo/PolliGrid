define(
	[

		'angular'
		'app'
		
	]

	(angular,app)->
		
		app.config(($stateProvider,$urlRouterProvider)->

			$stateProvider
				
				.state 'home',

					url:"/"

					views:

						'header':

							templateUrl:'views/partials/header.html'
							
						
						'content':

							templateUrl:'views/partials/content.html'
							controller:'ContentCtrl'						

						"result@home":
							
							templateUrl :'views/partials/targetQuestions.html'
							controller:'TargetAudienceCtrl'


				.state 'home.login',
					url:'login'
					onEnter:($state,$modal,$location)->
						$modal.open(
						
							templateUrl : 'views/modals/authmodal.html'
							controller 	: "AuthCtrl"
							windowClass : "authModal "
						
						).result.then ()->
  						
  							console.log('modal is open')
						
						, ()->
							$location.path('/')
  							
				.state 'home.signup',
					url:'signup'
					onEnter:($state,$modal,$location)->
						$modal.open(
							
							templateUrl : 'views/modals/authmodal.html'
							controller 	: "AuthCtrl"
							windowClass : 'authModal'
						
						).result.then ()->
  						
  							console.log('modal is open')
						
						, ()->
							$location.path('/')

				.state 'home.create',
					url:'create'
					views:

						'create@':

							templateUrl:'views/partials/createQuestion.html'
							
						
						'target@':

							templateUrl:'views/partials/targetAudience.html'

						'share@':

							templateUrl:'views/partials/shareQuestion.html'

					onEnter:($state,$modal,$location)->
						
						$modal.open(
						
							templateUrl : 'views/modals/createModal.html'
							controller 	: "CreateCtrl"
							windowClass : "createModal"
							
						
						).result.then ()->
  							console.log('modal is open')
						
						, ()->
							$location.path('/')

				.state 'home.share',
					url:'share/:id'
					onEnter:($state,$modal,$stateParams,$location)->
						
						if $stateParams.id is "" 

							$location.path('/')

						else

							$modal.open(
							
								templateUrl : 'views/modals/shareModal.html'
								controller 	: "ShareCtrl"
								windowClass : "shareModal"
								
							
							).result.then ()->
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')

		
							
						
						

					

			$urlRouterProvider.otherwise('/')

		)
)