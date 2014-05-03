define ['angular'], (angular) ->
	angular.module('myapp.template', [])
			
			.run ($templateCache)->
				$templateCache.put "question.html",'
					<li ng-hide="targetQ.isQuestionAnswered" class=\'answer\'>
						<label class=\'pointer\'>
							<input ng-model="answer" type="radio" name="answer" ng-value="#OBJ#">
								{{#OBJ#.title}}
						</label>
					</li>'
				
			.run ($templateCache)->
				$templateCache.put "targetQuestion-options.html",'
					<li class="answer">
						<label class="pointer">
							<input ng-model="targetAnswer" type="radio" name="targetAnswer" ng-value="#OBJ#.option">
							{{#OBJ#.option}}
						</label>
					</li>'


			.run ($templateCache)->
				$templateCache.put "targetQuestion.html","
						<p class='question'>
							{{#OBJ#.question}}
						</p>
						
						<!-- Warning message -->
						<p ng-show=\"warning\" class=\"animated fadeIn alert alert-danger\">
							Please select something
						</p>
					"
			.run ($templateCache)->
				$templateCache.put "result.html","
						<li class='answer gray'>		
							{{#OBJ#.title}}: 
							<span>
								{{#OBJ#.count}}
							</span>
						</li>
					"

				
			


		