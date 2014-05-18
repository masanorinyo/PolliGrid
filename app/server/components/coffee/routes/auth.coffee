# authentication handler

# --------------------------------------------#
# ------------   Dependencies    ------------ #
# --------------------------------------------#
User = require("../models/user")
auth_utility = require("../lib/auth-utility")

# ----------------- utility functions ----------------- #
escapeChar = (regex)->
	regex.replace(/([()[{*+.$^\\|?])/g, '\\$1')


# fs = require("fs")
verification = require("../lib/verification")


# --------------------------------------------#
# ------------  exports modeul   ------------ #
# --------------------------------------------#

module.exports = (app,passport) ->


	#======== Authentication ========//

	# login authentication
	app.post "/api/auth/login", passport.authenticate("local-login"), (req, res,next) ->
		
		if req.user

			res.send(req.user)


		else 

			res.send(req.session.message)
		

	# Signup authentication
	app.post "/api/auth/signup",passport.authenticate("local-signup"),(req, res, next) ->
		
		if req.user

			res.send(req.user)

		else
			
			res.send(req.session.message)

   
  #Facebook
	app.get "/auth/facebook", passport.authenticate("facebook",
		scope: [
			"email"
			"read_stream"
			"publish_actions"
		]
	)

	app.get "/api/getLoggedInUser",(req,res)->
		res.send req.user

  # handle the callback after facebook has authenticated the user
	app.get "/auth/facebook/callback", passport.authenticate("facebook",

		failureRedirect: "/#/oauth/fail"

	), (req, res) ->

		res.redirect "/#/oauth/success"


  
#   #Twitter
#   app.get "/auth/twitter", passport.authenticate("twitter",
#     scope: [
#       "email"
#       "photo"
#     ]
#   )
  
#   # handle the callback after twitter has authenticated the user
#   app.get "/auth/twitter/callback", passport.authenticate("twitter",
#     failureRedirect: "/"
#   ), (req, res) ->
#     auth_utility.rememberOauth req, res
    
#     #check if users have an email address
#     unless req.user.profile.hasEmail
#       res.redirect "/getEmail"
#     else
#       res.redirect "/room/" + req.user.profile.username + "/me"
#     return

#   app.get "/getEmail", (req, res) ->
#     req.session.errorMessage = ""  unless req.session.errorMessage
#     res.render "auth/getEmail.jade",
#       errorMessage: req.session.errorMessage
#     , auth_utility.cleanup(req, res)
#     return

#   app.post "/getEmail/complete", (req, res) ->
#     User.findById req.user.id, (err, user) ->
#       if err
#         console.log err
#         req.session.destroy ->
#           req.logout()
#           res.redirect "/"
#           return

#       else
#         User.findOne
#           "profile.email": req.body.email
#         , (err, existingUser) ->
#           if err
#             throw errres.redirect "/"
#           else if existingUser
#             req.session.errorMessage = "That Email is already used"
#             res.redirect "/getEmail"
#           else
#             user.profile.email = req.body.email
#             user.profile.hasEmail = true
#             user.save (err, user) ->
#               if err
#                 throw errres.redirect "/"
#               else
                
#                 #log user's signup activity
#                 auth_utility.writeLog user.profile.username, user.id, "Twitter signup"
#                 verification.sendVerification req, user, user.profile.email
#                 res.redirect "/room/" + req.user.profile.username + "/me"
#               return

#           return

#       return

#     return

  
#   #Google
#   app.get "/auth/google", passport.authenticate("google",
#     scope: [
#       "profile"
#       "email"
#     ]
#   )
  
#   # the callback after google has authenticated the user
#   app.get "/auth/google/callback", passport.authenticate("google",
#     failureRedirect: "/"
#   ), (req, res) ->
#     console.log req
#     auth_utility.rememberOauth req, res
#     res.redirect "/room/" + req.user.profile.username + "/me"
#     return



  
	# ====== Delete Account ======#
	
	app.delete "/api/auth/logout", (req, res) ->
		if req.user
			console.log req.user
			req.logout()
			console.log req.user
			
				
			
			
			

			


	# verification
	app.get "/api/user/:id/:email/:task/:pass",(req,res) ->
		console.log id = escapeChar(unescape(req.params.id))
		console.log email = unescape(req.params.email)
		console.log task = unescape(req.params.task)
		console.log pass = unescape(req.params.pass)
		console.log 'test'
		isCorrect = false
		if task == "findById"

			User.findById id, (err,user) ->
				
				if err 
				
					res.send("foundUser",{foundUser:false})
				
				else if user

					res.send("foundUser",{foundUser:true})

				else 

					res.send("foundUser",{foundUser:false})

		else if task == "findByEmail"

			User.find({"local.email":email},(err,user)-> 
				
				if err 
					res.send err 
				else
					console.log user
					res.send user
			)
			
		else if task == "checkPass"

			User.findOne({"local.email":email},(err,user)->

				if err
					res.send isCorrect
				
				else if user
					
					validPass = user.validPassword(pass)
					isCorrect = true  if validPass
					console.log isCorrect
					res.send isCorrect
				
				else
				
					res.send isCorrect
			)


	# resetting password
	app.post '/api/resetPass/:email/:pass',(req,res)->
		console.log email = unescape(req.params.email)
		console.log pass = unescape(req.params.pass)
		User.findOne({"local.email":email},(err,user)->
			if err 
				res.send err 
			else if user

				newUser = new User()
				newPassword = newUser.generateHash(pass)
				user.local.password = newPassword

				user.save (err, user) ->
					if err
						throw err
					else
						
						res.send user
					
		)
		
	


  app.post "/upload", (req, res) ->
    fs.readFile req.files.localPhoto.path, (err, data) ->
      if err
        res.send 403
      else
        if req.files.localPhoto.type isnt "image/png" and req.files.localPhoto.type isnt "image/jpeg" and req.files.localPhoto.type isnt "image/gif"
          res.send 403
        else
          newPath = __dirname + "/../public/images/" + req.user.profile.username + ".jpg"
          fs.writeFile newPath, data, (err) ->
            if err
              throw err
            else
              req.user.profile.photos.local = req.protocol + "://" + req.get("host") + "/images/" + req.user.profile.username + ".jpg"
              req.user.save()
              res.redirect "back"
            return

      return

    return

  
	#resend a verification code
	app.post "/api/resend", (req, res) ->
		console.log 'resend'
		console.log user = req.body.user
		

		if user
			verification.sendVerification req, user, user.email
		


	# check if the input password is correct
	app.get "/api/checkPass", (req, res,next) ->
		isCorrect = false

		User.findOne
			"local.email": req.body.email
		, (err, user) ->
			
			
		  
#   #======== Verification Email ========//
  
#   #when users click the link provided in the account verification email
	app.get "/verify/:token", (req, res, next) ->
		token = req.params.token

		#if the token provided in the link matches 
		#the user's affiliated token in the database
		verification.verifyUser token, "verify", (err, user) ->
			
			if err
				res.redirect "/#/verification/email/fail"
			else unless user
				res.redirect "/#/verification/email/fail"
			else
				res.redirect "/#/verification/email/success"
			return

		return

  
  #======== Reset Password ========//
  
  
  # when users submit their emails to get a password reset email.
	app.post "/api/reset", (req, res, next) ->
		console.log "req.body.email"
		console.log req.body.email
		User.findOne
			"local.email": req.body.email
		, (err, user) ->
			if err
				res.send "fail"

			#if user is not found with that Email, add an error message into the session
			else unless user

				res.send "fail"

			#if user is found with that Email, send a Email.
			else

				verification.sendResetVerification req, user, user.local.email
				res.send "success"


  
  # users get E-mail with the link, which contains the token
	app.get "/reset/:token", (req, res, next) ->
		token = req.params.token
		
		#check if the token provided in the E-mail matches the user's affiliated token in the database
		verification.verifyUser token, "reset", (err, user) ->
			if err
      
				res.redirect "/verification/email/resetFail"
      
			else unless user

				res.redirect "/verification/email/resetFail"

			else

				#if the tokens match, then renders 'newPass jade' with
				#the user's email loaded
				res.render "newPass.jade",
					acctEmail: user.local.email


  
	#when users submit their new password on the "newPass.jade"
	app.post "/reset/verified", ((req, res, next) ->
		type = req.params.type
    
		#first find the user in the database with the submitted E-mail
		User.findOne
			"local.email": req.body.email
		, (err, user) ->
			if err
        
				res.redirect "/#/verification/pass/fail"

			else
        
				#IF THE USER IS FOUND, THEN SET A NEW PASSWORD FOR HIS OR HER ACCOUNT
				newUser = new User()
				newPassword = newUser.generateHash(req.body.password)
				user.local.password = newPassword
				
				user.save (err, user) ->
					if err
						res.redirect "/#/verification/pass/fail"
					else
						next()
				
  
	 #  #once the user successfully set a new password,
	 #  # authenticate with passportJS
	 #  ), passport.authenticate("local-login",
		# failureRedirect: "/#/verification/pass/fail"
	  
	  #if the user is authenticated, stores the user's id in cookies
	  #so that the user won't need to retype the password in the future.
	  ), (req, res, next) ->
		res.redirect "/#/verification/pass/success"
	    

	  

	  
