

# #remember me function for oAuthentication
exports.rememberOauth = (req, res) ->
  
	#remember it for one year - 60 secounds * 60 mins * 24 hours * 365 days
	req.session.cookie.maxAge = 60000 * 60 * 24 * 365
	return


#remember me function for local login and signup
exports.rememberMe = (req, res) ->

	if req.body.remember_me
		
		#remember it for one year - 60 secounds * 60 mins * 24 hours * 365 days
		req.session.cookie.maxAge = 60000 * 60 * 24 * 365
	
	else
		req.session.cookie.expires = false



# route middleware to ensure user is logged in
exports.isLoggedIn = (req, res, next) ->
	if req.isAuthenticated()
		
		next()
	
	else
	
		res.redirect "/"
	

exports.isInvited = (req, res) ->
	
	isInvited = false
	

# clean up the session after error shows up
exports.cleanup = (req, res) ->
	req.session.message = ""