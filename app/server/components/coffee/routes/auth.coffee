# authentication handler

exports.index = (req,res)->
	res.send('test')

# #--load user model--//
# User = require("../models/user")
# fs = require("fs")
# verification = require("../lib/verification")
# auth_utility = require("../lib/auth-utility")
# fbgraph = require("fbgraph")
# Twit = require("twit")

# # ********************** Module export **********************//
# module.exports = (app, passport) ->
  
#   #======== Normal routes ========//
#   #Home page
#   app.get "/", (req, res) ->
#     req.app.locals.chatroom = null
#     req.session.errorMessage = ""  unless req.session.errorMessage
#     if req.user
#       res.redirect "/room/" + req.user.profile.username + "/me"
#     else
#       res.render "contents/index.jade",
#         message: req.session.errorMessage
#       , auth_utility.cleanup(req, res)
#     return

  
#   # post a message on different social networks
#   app.get "/post/:platform", (req, res) ->
#     platform = req.params.platform
#     wallPost = message: req.query.message + "\n" + req.query.url
#     if platform is "facebook"
#       fb_token = req.user.facebook.token
#       fbgraph.setAccessToken fb_token
#       fbgraph.post req.user.facebook.id + "/feed", wallPost, (err, res) ->
#         console.log res
#         return

#     else if platform is "twitter"
#       T = new Twit(
#         consumer_key: "Nb3QUO3hjbWbtmIZHaYDvrbo6"
#         consumer_secret: "KK47AQIDZGrK7bULZxmvjQmuil04YU2bInuX82qUxwXiqohChm"
#         access_token: req.user.twitter.token
#         access_token_secret: req.user.twitter.tokenSecret
#       )
#       console.log req.user.twitter.token + " secret:" + req.user.twitter.tokenSecret
#       T.post "statuses/update",
#         status: wallPost.message
#       , (err, reply) ->
#         console.log reply
#         return

#     else if platform is "all"
#       fb_token = req.user.facebook.token
#       fbgraph.setAccessToken fb_token
#       fbgraph.post req.user.facebook.id + "/feed", wallPost, (err, res) ->
#         console.log res
#         return

#       T = new Twit(
#         consumer_key: "Nb3QUO3hjbWbtmIZHaYDvrbo6"
#         consumer_secret: "KK47AQIDZGrK7bULZxmvjQmuil04YU2bInuX82qUxwXiqohChm"
#         access_token: req.user.twitter.token
#         access_token_secret: req.user.twitter.tokenSecret
#       )
#       console.log req.user.twitter.token + " secret:" + req.user.twitter.tokenSecret
#       T.post "statuses/update",
#         status: wallPost.message
#       , (err, reply) ->
#         console.log reply
#         return

#     return

  
#   #Setting
#   app.get "/setting", auth_utility.isLoggedIn, (req, res) ->
    
#     #check if the user has an email address
#     unless req.user.profile.hasEmail
#       req.logout()
#       req.session.cookie.expires = false
#     if req.user
      
#       #this will get the account's name if it is the only connected account.
#       #if there are multiple accounts connected, the variable will be 'undefined'
#       #if this variable is defined as one account, the described account will not show the unlink button.
#       onlyOneConnectedAccount = auth_utility.checkAccountStatus(req.user)
#       res.render "auth/setting.jade",
#         user: req.user
#         account: onlyOneConnectedAccount
#         userPhoto: req.user.profile.primaryPhoto
#         username: req.user.profile.username
#         isLoggedIn: req.user
#         myname: req.user.profile.username
#         isVerified: req.user.profile.confirmed
#         onSettingPage: true

#     else
#       res.redirect "/"
#     return

#   app.post "/defaultPhoto/:type", (req, res) ->
#     type = req.params.type
#     console.log req.user.id
#     User.findOne
#       _id: req.user.id
#     , (err, user) ->
#       if err
#         throw err
#       else if user
#         if type is "facebook"
#           user.profile.primaryPhoto = req.user.profile.photos.facebook
#           user.save()
#           res.send user.profile.primaryPhoto
#         else if type is "twitter"
#           user.profile.primaryPhoto = req.user.profile.photos.twitter
#           user.save()
#           res.send user.profile.primaryPhoto
#         else if type is "google"
#           user.profile.primaryPhoto = req.user.profile.photos.google
#           user.save()
#           res.send user.profile.primaryPhoto
#         else if type is "local"
#           user.profile.primaryPhoto = req.user.profile.photos.local
#           user.save()
#           res.send user.profile.primaryPhoto
#       return

#     return

#   app.post "/upload", (req, res) ->
#     fs.readFile req.files.localPhoto.path, (err, data) ->
#       if err
#         res.send 403
#       else
#         if req.files.localPhoto.type isnt "image/png" and req.files.localPhoto.type isnt "image/jpeg" and req.files.localPhoto.type isnt "image/gif"
#           res.send 403
#         else
#           newPath = __dirname + "/../public/images/" + req.user.profile.username + ".jpg"
#           fs.writeFile newPath, data, (err) ->
#             if err
#               throw err
#             else
#               req.user.profile.photos.local = req.protocol + "://" + req.get("host") + "/images/" + req.user.profile.username + ".jpg"
#               req.user.save()
#               res.redirect "back"
#             return

#       return

#     return

  
#   #resend a verification code
#   app.get "/resend", (req, res) ->
#     req.session.errorMessage = ""  unless req.session.errorMessage
#     if req.user
#       verification.sendVerification req, req.user, req.user.profile.email
#       res.redirect "/setting"
#     else
#       req.session.errorMessage = "Please log into your account"
#       res.redirect "/"
#     return

  
#   # check if the input password is correct
#   app.get "/checkPass", (req, res) ->
#     isCorrect = false
#     User.findOne
#       "local.email": req.user.local.email
#     , (err, user) ->
#       if err
#         res.send isCorrect
#       else if user
#         validPass = user.validPassword(req.query.oldPass)
#         isCorrect = true  if validPass
#         res.send isCorrect
#       else
#         res.send isCorrect
#       return

#     return

  
#   #Logout
#   app.get "/logout", (req, res) ->
    
#     #log user's logout activity
#     auth_utility.writeLog req.user.profile.username, req.user.id, "Logged off"
#     req.logout()
#     req.session.cookie.expires = false
#     res.redirect "/"
#     return

  
#   #Delete Account
#   app.get "/delete", (req, res) ->
#     if req.user
#       User.remove (err, user) ->
#         req.session.destroy ->
#           req.logout()
#           return

#         if err
#           throw err
#         else
          
#           #log user's deleting activity
#           auth_utility.writeLog req.user.profile.username, req.user.id, "Deleted"
#           User.findById req.user.id, (err, user) ->
#             res.redirect "/"
#             return

#         return

#     else
#       res.redirect "/"
#     return

  
#   #======== Verification Email ========//
  
#   #when users click the link provided in the account verification email
#   app.get "/verify/:token", (req, res, next) ->
#     token = req.params.token
    
#     #if the token provided in the link matches 
#     #the user's affiliated token in the database
#     verification.verifyUser token, "verify", (err, user) ->
#       if err
#         res.redirect "/"
#       else unless user
#         res.redirect "/"
#       else
        
#         #log user's verifying account activity
#         auth_utility.writeLog user.profile.username, user.id, "Verified account"
#         res.redirect "/room/" + req.user.profile.username + "/me"
#       return

#     return

  
#   #======== Reset Password ========//
#   app.get "/reset", (req, res, next) ->
    
#     #Define the error message in session if it is undefined.
#     req.session.errorMessage = ""  unless req.session.errorMessage
    
#     #the error message in session gets emptified after rendering
#     res.render "auth/resetPass.jade",
#       errorMessage: req.session.errorMessage
#     , auth_utility.cleanup(req, res)
#     return

  
#   # when users submit their emails to get a password reset email.
#   app.post "/reset/verifyEmail", (req, res, next) ->
#     User.findOne
#       "local.email": req.body.email
#     , (err, user) ->
#       if err
#         done err
      
#       #if user is not found with that Email, add an error message into the session
#       else unless user
#         req.session.errorMessage = "There is no user registered with that Email"
#         res.redirect "/reset"
      
#       #if user is found with that Email, send a Email.
#       else
        
#         #log the time of reset email sent out
#         auth_utility.writeLog user.profile.username, user.id, "asked for password reset"
#         verification.sendResetVerification req, user, user.local.email
#         res.redirect "/login"
#       return

#     return

  
#   # users get E-mail with the link, which contains the token
#   app.get "/reset/:token", (req, res, next) ->
#     token = req.params.token
    
#     #check if the token provided in the E-mail matches the user's affiliated token in the database
#     verification.verifyUser token, "reset", (err, user) ->
#       if err
#         res.redirect "/"
#       else unless user
#         res.redirect "/"
#       else
        
#         #if the tokens match, then renders 'newPass jade' with
#         #the user's email loaded
#         res.render "auth/newPass.jade",
#           acctEmail: user.local.email

#       return

#     return

  
#   #when users submit their new password on the "newPass.jade"
#   app.post "/reset/verified/:type", ((req, res, next) ->
#     type = req.params.type
    
#     #first find the user in the database with the submitted E-mail
#     User.findOne
#       "local.email": req.body.email
#     , (err, user) ->
#       if err
#         console.log err
#         res.redirect "/"
#       else
        
#         #if the user is found, then set a new password for his or her account
#         newUser = new User()
#         newPassword = newUser.generateHash(req.body.password)
#         user.local.password = newPassword
#         user.save (err, user) ->
#           if err
#             throw err
#           else
#             if type is "resetPass"
              
#               #log user's reset password activity
#               auth_utility.writeLog user.profile.username, user.id, "Reset password"
#               next()
#             else if type is "changePass"
              
#               #log user's reset password activity
#               auth_utility.writeLog user.profile.username, user.id, "Changed password"
#               res.redirect "/setting"
#             else
#               res.redirect "/setting"
#           return

#       return

#     return
  
#   #once the user successfully set a new password,
#   # authenticate with passportJS
#   ), passport.authenticate("local-login",
#     failureRedirect: "/login"
  
#   #if the user is authenticated, stores the user's id in cookies
#   #so that the user won't need to retype the password in the future.
#   ), (req, res, next) ->
#     auth_utility.rememberMe req, res
#     res.redirect "/room/" + req.user.profile.username + "/me"
#     return

  
#   #======== Authentication ========//
#   #local login
#   app.get "/login", (req, res) ->
#     req.session.loginMessage = ""  unless req.session.loginMessage
#     if req.user
#       res.redirect "/room/" + req.user.profile.username + "/me"
#     else
      
#       #clean up empties the login session message.
#       res.render "auth/login.jade",
#         message: req.session.loginMessage
#       , auth_utility.cleanup(req, res)
#     return

  
#   # login authentication
#   app.post "/login", passport.authenticate("local-login",
#     failureRedirect: "/login" # redirect back to the signup page if there is an error
#   ), (req, res) ->
#     auth_utility.rememberMe req, res
#     res.redirect "/room/" + req.user.profile.username + "/me"
#     return

  
#   # Local signup
#   app.get "/signup", (req, res) ->
#     req.session.signupMessage = ""  unless req.session.signupMessage
#     if req.user
#       res.redirect "/room/" + req.user.profile.username + "/me"
#     else
      
#       #clean up empties the signup session message
#       res.render "auth/signup.jade",
#         message: req.session.signupMessage
#       , auth_utility.cleanup(req, res)
#     return

  
#   # Signup authentication
#   app.post "/signup", passport.authenticate("local-signup",
#     failureRedirect: "/signup" # redirect back to the signup page if there is an error
#   ), (req, res, next) ->
#     auth_utility.rememberMe req, res, next
#     res.redirect "/room/" + req.user.profile.username + "/me"
#     return

  
#   #Facebook
#   app.get "/auth/facebook", passport.authenticate("facebook",
#     scope: [
#       "email"
#       "read_stream"
#       "publish_actions"
#     ]
#   )
  
#   # handle the callback after facebook has authenticated the user
#   app.get "/auth/facebook/callback", passport.authenticate("facebook",
#     failureRedirect: "/"
#   ), (req, res) ->
#     auth_utility.rememberOauth req, res
#     res.redirect "/room/" + req.user.profile.username + "/me"
#     return

  
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

  
#   #======== Authorization ========//
#   # Local authorization
#   app.get "/connect/local", (req, res) ->
#     req.session.signupMessage = ""  unless req.session.signupMessage
#     if not req.user or req.user.local.email
#       res.redirect "/setting"
#     else
#       res.render "auth/connect-local.jade",
#         message: req.session.signupMessage
#       , auth_utility.cleanup(req, res)
#     return

#   app.post "/connect/local/submitted", passport.authenticate("local-signup",
#     successRedirect: "/setting" # redirect to the secure setting section
#     failureRedirect: "/connect/local" # redirect back to the signup page if there is an error
#   )
  
#   # facebook authorization
  
#   # send to facebook to do the authentication
#   app.get "/connect/facebook", ((req, res, next) ->
#     res.redirect "/"  unless req.user
#     next()
#     return
#   ), passport.authenticate("facebook-connect",
#     scope: "email"
#   )
  
#   # handle the callback after facebook has authorized the user
#   app.get "/connect/facebook/callback", ((req, res, next) ->
#     res.redirect "/"  unless req.user
#     next()
#     return
#   ), passport.authenticate("facebook-connect",
#     successRedirect: "/setting"
#     failureRedirect: "/"
#   )
  
#   # twitter authorization
  
#   # send to twitter to do the authentication
#   app.get "/connect/twitter", ((req, res, next) ->
#     res.redirect "/"  unless req.user
#     next()
#     return
#   ), passport.authenticate("twitter-connect",
#     scope: "email"
#   )
  
#   # handle the callback after twitter has authorized the user
#   app.get "/connect/twitter/callback", ((req, res, next) ->
#     res.redirect "/"  unless req.user
#     next()
#     return
#   ), passport.authenticate("twitter-connect",
#     successRedirect: "/setting"
#     failureRedirect: "/"
#   )
  
#   # google authorization
  
#   # send to google to do the authentication
#   app.get "/connect/google", ((req, res, next) ->
#     res.redirect "/"  unless req.user
#     next()
#     return
#   ), passport.authenticate("google-connect",
#     scope: [
#       "profile"
#       "email"
#     ]
#   )
  
#   # the callback after google has authorized the user
#   app.get "/connect/google/callback", ((req, res, next) ->
#     res.redirect "/"  unless req.user
#     next()
#     return
#   ), passport.authenticate("google-connect",
#     successRedirect: "/setting"
#     failureRedirect: "/"
#   )
  
#   #======== Unlink ========//
#   # used to unlink accounts. for social accounts, just remove the token
#   # for local account, remove email and password
#   # user account will stay active in case they want to reconnect in the future
  
#   # local unlink
#   app.get "/unlink/local", (req, res) ->
#     user = req.user
#     res.redirect "/"  unless user
    
#     #log user's unlinking activity
#     auth_utility.writeLog user.profile.username, user.id, "Local unlinked"
#     user.local.email = `undefined`
#     user.local.password = `undefined`
#     user.save (err) ->
#       res.redirect "/setting"
#       return

#     return

  
#   # facebook unlink
#   app.get "/unlink/facebook", (req, res) ->
#     user = req.user
#     res.redirect "/"  unless user
    
#     #log user's unlinking activity
#     auth_utility.writeLog user.profile.username, user.id, "facebook unlinked"
#     user.facebook.token = `undefined`
#     user.save (err) ->
#       res.redirect "/setting"
#       return

#     return

  
#   # twitter unlink
#   app.get "/unlink/twitter", (req, res) ->
#     user = req.user
#     res.redirect "/"  unless user
    
#     #log user's unlinking activity
#     auth_utility.writeLog user.profile.username, user.id, "Twitter unlinked"
#     user.twitter.token = `undefined`
#     user.save (err) ->
#       res.redirect "/setting"
#       return

#     return

  
#   # google unlink
#   app.get "/unlink/google", (req, res) ->
#     user = req.user
#     res.redirect "/"  unless user
    
#     #log user's unlinking activity
#     auth_utility.writeLog user.profile.username, user.id, "Google unlinked"
#     user.google.token = `undefined`
#     user.save (err) ->
#       res.redirect "/setting"
#       return

#     return

#   return