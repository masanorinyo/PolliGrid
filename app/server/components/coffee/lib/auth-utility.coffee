# fs = require("fs")
# exports.writeLog = (user, id, activity) ->
  
#   #create a file with appending function
#   logFile = fs.createWriteStream("./log/userActivities.txt",
#     flags: "a"
#     encoding: "encoding"
#     mode: 0744
#   )
#   logFile.write "User: " + user + " - id: " + id + " - " + "Activity: " + activity + " - " + "When: " + new Date() + "\n"
#   return


# #check on the connection status of other accounts
# #if all the other accounts are not connected, this will return "false"
# exports.checkAccountStatus = (user) ->
  
#   #when the connection status of account is true,
#   #then that account will be pushed into acct array.
#   acct = []
#   status =
#     local: false
#     facebook: false
#     twitter: false
#     google: false

  
#   #check the connection status of each account
#   status.local = true  if user.local.email
#   status.facebook = true  if user.facebook.token
#   status.twitter = true  if user.twitter.token
#   status.google = true  if user.google.token
#   i = 0
  
#   #check how many accounts are connected.
#   for key of status
    
#     #if the status is true, then push the account into the acct array
#     #this will show which accounts are connected
#     if status[key]
#       i++
#       acct.push key
#   if i is 1
    
#     #if the number of connected accounts is only one, 
#     #return the connected account		
#     console.log "There is only " + acct[0] + " connected"
#     acct[0]
#   else
    
#     #if there are multiple accounts connected, then return false
#     console.log "There are multiple accounts connected"
#     false


# #remember me function for oAuthentication
# exports.rememberOauth = (req, res) ->
  
#   #remember it for one year - 60 secounds * 60 mins * 24 hours * 365 days
#   req.session.cookie.maxAge = 60000 * 60 * 24 * 365
#   return


# #remember me function for local login and signup
# exports.rememberMe = (req, res) ->
#   if req.body.remember_me
    
#     #remember it for one year - 60 secounds * 60 mins * 24 hours * 365 days
#     req.session.cookie.maxAge = 60000 * 60 * 24 * 365
#   else
#     req.session.cookie.expires = false
#   return


# # route middleware to ensure user is logged in
# exports.isLoggedIn = (req, res, next) ->
#   if req.isAuthenticated()
#     next()
#   else
#     res.redirect "/"
#   return

# exports.isInvited = (req, res) ->
#   isInvited = false
#   isInvited = false


# # clean up the session after error shows up
# exports.cleanup = (req, res) ->
#   req.session.signupMessage = ""
#   req.session.loginMessage = ""
#   req.session.errorMessage = ""
#   return