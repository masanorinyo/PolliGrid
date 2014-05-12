# --------------------------------------------#
# ------------ load dependencies ------------ #
# --------------------------------------------#
LocalStrategy = require("passport-local").Strategy
FacebookStrategy = require("passport-facebook").Strategy
TwitterStrategy = require("passport-twitter").Strategy
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy

# -- model
User = require("../models/user")
# configAuth = require("../routes/auth")

# email verification
# verification = require("../app/lib/verification")

# --------------------------------------------#
# ------------ load dependencies ------------ #
# --------------------------------------------#

#make user's name unique by concatenating a number to the name
#once the name becomes unique, callback function
uniqify_name = (name, num, callback) ->
	User.findOne
    
    	"name": name
	
	, (err, user) ->
		if err
			throw err
		
		else if user
		
			stringNum = num.toString()
			name = name.concat(stringNum)
			num++
			uniqify_name(name,num,callback)
		else
			callback(name)
			

# --------------------------------------------#
# ------------  exports modeul   ------------ #
# --------------------------------------------#

module.exports = (passport) ->
  
	#--serialize users for persistent login sessions--//
	passport.serializeUser (user, done) ->
		done(null, user.id)
    
	#--deserialize users out of session--//
	passport.deserializeUser (id, done) ->
		User.findById(id, (err, user) ->
			done(err, user)
		)
  

  	# ========== Local Login ========== #
	passport.use "local-login", new LocalStrategy(
			
		usernameField: "email"
		passwordField: "password"
		passReqToCallback: true
		
		, (req, email, password, done) ->
			console.log req
			req.session.message = ""
			
			process.nextTick ->
				User.findOne
					"local.email": email
				, (err, user) ->
					if err
						done err
					else unless user
						req.session.message = "No user found"
						done null, false, req.session.message
					else unless user.validPassword(password)
						req.session.message = "Wrong password"
						done null, false, req.session.message
					else
						done null, user
	)
	# ========== Local Signup ========== #
	
	passport.use "local-signup", new LocalStrategy(
    
		#Overwrites the default usernameField with email
		usernameField: "email"
		passwordField: "password"
		    
		#This will allow in checking if a user is logged in
		#(passes user data in the req from the router)
		passReqToCallback: true
		
		, (req, email, password, done) ->
	    	
			#clears out the session message
			req.session.message = ""
			
			process.nextTick ->
				User.findOne
					
					"local.email": email
				
				, (err, user) ->
					if err
					
						done(err)
					
					else if user
						
						req.session.message = "That Email is already taken"
						done(null, false, req.session.message)
					
					else

						# create a new user if there are no error and 
						# a user already using the Email in the process

						#get a name from Email
						nameMatch = email.match(/^([^@]*)@/)
						name = (if nameMatch then nameMatch[1] else null)

						#if name is successfully extracted from email
						if name


							callback = (name) ->
								
								newUser = new User()

								newUser.username = name
								newUser.email = email
								newUser.profilePic = "/img/users/default_img.png"

								# Stores email and hashed password into a new user variable.
								newUser.local.email = email
								newUser.local.password = newUser.generateHash(password)

								#once users verify the account by clicking the link provided 
								#in the verification Email, this will become true
								newUser.confirmed = false

								#when users sign up with their twitter account
								#they need to submit their email separately
								newUser.hasEmail = true
								
								newUser.save (err, user) ->
									if err
										
										done(err)

									else

										# verification.sendVerification(req, newUser, email)
										done(null, newUser)

							#check if there is any user already using the name
							#if any user with the same name, concatenate with a number
							#untill the name becomes unique
							#once the name becomes unique, then the user information will be saved with the callback function.
							uniqify_name(name, 1, callback)

						else
										
							done(null)

	)
  
  # #========================== Facebook ==========================//
  # #*********** Signup & Login ***********//
  # passport.use "facebook", new FacebookStrategy(
  #   clientID: configAuth.facebookAuth.clientID
  #   clientSecret: configAuth.facebookAuth.clientSecret
  #   callbackURL: configAuth.facebookAuth.callbackURL
    
  #   #This will allow in checking if a user is logged in
  #   #(passes user data in the req from the router)
  #   passReqToCallback: true
  # , (req, token, refreshToken, profile, done) ->
  #   process.nextTick ->
  #     picture = profile.username
  #     picUrl = "https://graph.facebook.com/" + picture + "/picture"
      
  #     # when the user is not logged in
  #     unless req.user
  #       User.findOne
  #         "facebook.id": profile.id
  #       , (err, user) ->
  #         if err
  #           done err
  #         else if user
            
  #           # if there is a user id already but no token 
  #           # (user was linked at one point and then removed)
  #           unless user.facebook.token
  #             user.facebook.token = token
  #             user.profile.photos.facebook = picUrl
  #             user.profile.gender = profile.gender
  #             user.save (err) ->
  #               if err
  #                 done err
  #               else
                  
  #                 #log user's reconnection activity
  #                 writeLog user.profile.username, user.id, "Facebook reconnect"
  #                 done null, user

  #           else
              
  #             #log user's logging activity
  #             writeLog user.profile.username, user.id, "Facebook Login"
              
  #             # the user is found
  #             done null, user
  #         else
            
  #           # if there is no user with facebook account
  #           # create a new user
  #           newUser = new User()
  #           newUser.facebook.id = profile.id
  #           newUser.facebook.token = token
  #           newUser.profile.username = profile.name.givenName + "-" + profile.name.familyName
  #           newUser.profile.email = profile.emails[0].value
  #           newUser.profile.primaryPhoto = picUrl
  #           newUser.profile.photos.facebook = picUrl
  #           newUser.profile.gender = profile.gender
            
  #           #once users verify the account by clicking the link provided 
  #           #in the verification Email, this will become true
  #           newUser.profile.confirmed = false
            
  #           #when users sign up with their twitter account
  #           #they need to submit their email separately
  #           newUser.profile.hasEmail = true
  #           newUser.save (err, user) ->
  #             if err
  #               done err
  #             else
                
  #               #log user's signup activity
  #               writeLog user.profile.username, user.id, "Facebook signup"
  #               verification.sendVerification req, newUser, newUser.profile.email
  #               done null, newUser

  #         return

  #     else
  #       done null
  #     return

  #   return
  # )
  
  # #*********** Authorization / Account Connect ***********//
  # passport.use "facebook-connect", new FacebookStrategy(
  #   clientID: configAuth.facebookAuth.clientID
  #   clientSecret: configAuth.facebookAuth.clientSecret
  #   callbackURL: configAuth.facebookAuth.connectCallbackURL
    
  #   #This will allow in checking if a user is logged in
  #   #(passes user data in the req from the router)
  #   passReqToCallback: true
  # , (req, token, refreshToken, profile, done) ->
  #   process.nextTick ->
  #     picture = profile.username
  #     picUrl = "https://graph.facebook.com/" + picture + "/picture"
      
  #     # (user was linked at one point and then removed)
  #     unless req.user.facebook.token
  #       user = req.user
  #       user.facebook.id = profile.id
  #       user.facebook.token = token
  #       user.profile.photos.facebook = picUrl
  #       user.profile.gender = profile.gender
  #       user.save (err) ->
  #         if err
  #           throw err
  #         else
            
  #           #log user's reconnection activity
  #           writeLog user.profile.username, user.id, "Facebook reconnect"
  #           done null, user
  #         return

  #     else
        
  #       # There is already a user logged in
  #       # This allows for linking Facebook account
  #       # gets the user out of the session
  #       user = req.user
  #       user.facebook.id = profile.id
  #       user.facebook.token = token
  #       user.profile.photos.facebook = picUrl
  #       user.profile.gender = profile.gender
  #       user.save (err) ->
  #         if err
  #           done err
  #         else
            
  #           #log user's authorizatoin activity
  #           writeLog user.profile.username, user.id, "Facebook Authorizatoin"
  #           done null, user

  #     return

  #   return
  # )
  
  # #========================== Twitter Login ==========================//
  # #*********** Signup & Login ***********//
  # passport.use "twitter", new TwitterStrategy(
  #   consumerKey: configAuth.twitterAuth.consumerKey
  #   consumerSecret: configAuth.twitterAuth.consumerSecret
  #   callbackURL: configAuth.twitterAuth.callbackURL
    
  #   #This will allow in checking if a user is logged in
  #   #(passes user data in the req from the router)
  #   passReqToCallback: true
  # , (req, token, tokenSecret, profile, done) ->
  #   process.nextTick ->
      
  #     # check if the user is already logged in
  #     unless req.user
  #       User.findOne
  #         "twitter.id": profile.id
  #       , (err, user) ->
  #         if err
  #           done err
  #         else if user
  #           console.log "twitter user : found"
            
  #           # if there is a user id already but no token 
  #           # (user was linked at one point and then removed)
  #           unless user.twitter.token
  #             console.log "twitter user : No token"
  #             user.twitter.token = token
  #             user.twitter.tokenSecret = tokenSecret
  #             user.profile.photos.twitter = profile.photos[0].value
  #             user.save (err) ->
  #               if err
  #                 done err
  #               else
                  
  #                 #log user's reconnection activity
  #                 writeLog user.profile.username, user.id, "Twitter reconnect"
  #                 done null, user

  #           else
  #             console.log "twitter user : id and token found"
              
  #             #log user's logging activity
  #             writeLog user.profile.username, user.id, "Twitter Login"
  #             done null, user # user found, return that user
  #         else
  #           console.log "twitter user : Nothing was found"
            
  #           # if there is no user, create them
  #           newUser = new User()
            
  #           #sends confirmation email
  #           newUser.twitter.id = profile.id
  #           newUser.twitter.token = token
  #           newUser.twitter.tokenSecret = tokenSecret
  #           newUser.profile.username = profile.displayName.replace(/\s/g, "-")
  #           newUser.profile.primaryPhoto = profile.photos[0].value
  #           newUser.profile.photos.twitter = profile.photos[0].value
            
  #           #When users submit the reset password form,
  #           #this will become true.
  #           newUser.profile.confirmed = false
            
  #           #when users sign up with their twitter account
  #           #they need to submit their email separately
  #           newUser.profile.hasEmail = false
  #           newUser.save (err) ->
  #             if err
  #               done err
  #             else
  #               done null, newUser

  #         return

  #     else
  #       console.log "twitter user : already loggedin"
        
  #       # There is already a user logged in
  #       # This allows for linking twitter account
  #       # gets the user out of the session
  #       user = req.user
  #       user.twitter.id = profile.id
  #       user.twitter.token = token
  #       user.twitter.tokenSecret = tokenSecret
  #       user.profile.photos.twitter = profile.photos[0].value
  #       user.save (err) ->
  #         if err
  #           done err
  #         else
            
  #           #log user's authorizatoin activity
  #           writeLog user.profile.username, user.id, "Twitter Authorizatoin"
  #           done null, user

  #     return

  #   return
  # )
  
  # #*********** Authorization ***********//
  # passport.use "twitter-connect", new TwitterStrategy(
  #   consumerKey: configAuth.twitterAuth.consumerKey
  #   consumerSecret: configAuth.twitterAuth.consumerSecret
  #   callbackURL: configAuth.twitterAuth.connectCallbackURL
    
  #   #This will allow in checking if a user is logged in
  #   #(passes user data in the req from the router)
  #   passReqToCallback: true
  # , (req, token, tokenSecret, profile, done) ->
  #   process.nextTick ->
  #     user = req.user
      
  #     # (user was linked at one point and then removed)
  #     unless user.twitter.token
  #       user.twitter.id = profile.id
  #       user.twitter.token = token
  #       user.twitter.tokenSecret = tokenSecret
  #       user.profile.photos.twitter = profile.photos[0].value
  #       user.save (err) ->
  #         if err
  #           done err
  #         else
            
  #           #log user's reconnection activity
  #           writeLog user.profile.username, user.id, "Twitter reconnect"
  #           done null, user

  #     else
        
  #       # There is already a user logged in
  #       # This allows for linking twitter account
  #       # gets the user out of the session
  #       user = req.user
  #       user.twitter.id = profile.id
  #       user.twitter.token = token
  #       user.twitter.tokenSecret = tokenSecret
  #       user.profile.photos.twitter = profile.photos[0].value
  #       user.save (err) ->
  #         if err
  #           done err
  #         else
            
  #           #log user's authorizatoin activity
  #           writeLog user.profile.username, user.id, "Twitter Authorizatoin"
  #           done null, user

  #     return

  #   return
  # )
  
  # #========================== Google+ Login ==========================//
  # #*********** Signup & Login ***********//
  # passport.use "google", new GoogleStrategy(
  #   clientID: configAuth.googleAuth.clientID
  #   clientSecret: configAuth.googleAuth.clientSecret
  #   callbackURL: configAuth.googleAuth.callbackURL
    
  #   #This will allow in checking if a user is logged in
  #   #(passes user data in the req from the router)
  #   passReqToCallback: true
  # , (req, token, refreshToken, profile, done) ->
    
  #   # asynchronous
  #   process.nextTick ->
      
  #     # check if the user is already logged in
  #     unless req.user
  #       User.findOne
  #         "google.id": profile.id
  #       , (err, user) ->
  #         if err
  #           done err
  #         else if user
            
  #           # if there is a user id already but no token 
  #           # (user was linked at one point and then removed)
  #           unless user.google.token
  #             user.google.token = token
  #             user.google.name = profile.displayName.replace(/\s/g, "-")
  #             user.profile.gender = profile._json.gender
  #             user.profile.photos.google = profile._json.picture
  #             user.save (err) ->
  #               if err
  #                 done err
  #               else
                  
  #                 #log user's reconnection activity
  #                 writeLog user.profile.username, user.id, "Google reconnect"
  #                 done null, user

  #           else
              
  #             #log user's logging activity
  #             writeLog user.profile.username, user.id, "Google login"
  #             done null, user
  #         else
            
  #           # if there is no user, create them
  #           newUser = new User()
            
  #           #sends confirmation email
  #           newUser.google.id = profile.id
  #           newUser.google.token = token
  #           newUser.profile.username = profile.displayName.replace(/\s/g, "-")
  #           newUser.profile.email = profile.emails[0].value # pull the first email
  #           newUser.profile.primaryPhoto = profile._json.picture
  #           newUser.profile.photos.google = profile._json.picture
  #           newUser.profile.gender = profile._json.gender
            
  #           #When users submit the reset password form,
  #           #this will become true.
  #           newUser.profile.confirmed = false
            
  #           #when users sign up with their twitter account
  #           #they need to submit their email separately
  #           newUser.profile.hasEmail = true
  #           newUser.save (err, user) ->
  #             if err
  #               done err
  #             else
                
  #               #log user's signup activity
  #               writeLog user.profile.username, user.id, "Google signup"
  #               verification.sendVerification req, newUser, newUser.profile.email
  #               done null, newUser

  #         return

  #     else
        
  #       # There is already a user logged in
  #       # This allows for linking google account
  #       # gets the user out of the session
  #       user = req.user
  #       user.google.id = profile.id
  #       user.google.token = token
  #       user.profile.photos.google = profile._json.picture
  #       user.profile.gender = profile._json.gender
  #       user.save (err) ->
  #         if err
  #           done err
  #         else
            
  #           #log user's authorizatoin activity
  #           writeLog user.profile.username, user.id, "Google Authorizatoin"
  #           done null, user

  #     return

  #   return
  # )
  
  # #*********** Authorization ***********//
  # passport.use "google-connect", new GoogleStrategy(
  #   clientID: configAuth.googleConnectAuth.clientID
  #   clientSecret: configAuth.googleConnectAuth.clientSecret
  #   callbackURL: configAuth.googleConnectAuth.connectCallbackURL
    
  #   #This will allow in checking if a user is logged in
  #   #(passes user data in the req from the router)
  #   passReqToCallback: true
  # , (req, token, refreshToken, profile, done) ->
    
  #   # asynchronous
  #   process.nextTick ->
  #     user = req.user
      
  #     # (user was linked at one point and then removed)
  #     unless user.google.token
  #       user.google.id = profile.id
  #       user.google.token = token
  #       user.google.name = profile.displayName.replace(/\s/g, "-")
  #       user.profile.gender = profile._json.gender
  #       user.profile.photos.google = profile._json.picture
  #       user.save (err) ->
  #         if err
  #           done err
  #         else
            
  #           #log user's reconnection activity
  #           writeLog user.profile.username, user.id, "Google reconnect"
  #           done null, user

  #     else
        
  #       # There is already a user logged in
  #       # This allows for linking google account
  #       # gets the user out of the session
  #       user.google.id = profile.id
  #       user.google.token = token
  #       user.profile.photos.google = profile._json.picture
  #       user.profile.gender = profile._json.gender
  #       console.log profile.id
  #       user.save (err) ->
  #         if err
  #           done err
  #         else
            
  #           #log user's authorizatoin activity
  #           writeLog user.profile.username, user.id, "Google Authorizatoin"
  #           done null, user

  #     return

  #   return
  # )
  # return