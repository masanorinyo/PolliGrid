# mail = require("./mail")
# verificationTokenModel = require("../models/verificationToken")
# User = require("../models/user")
# createVerification = (req, user, email) ->
#   verificationToken = new verificationTokenModel(_userId: user._id)
#   @send = (info, type) ->
#     verificationToken.createVerificationToken (err, token) ->
#       if err
#         console.log "Couldn't create verification token", err
#       else
#         info.textContent += req.protocol + "://" + req.get("host") + "/" + type + "/" + token
#         info.htmlContent += req.protocol + "://" + req.get("host") + "/" + type + "/" + token
#         mail info, (error, success) ->
#           if error
#             console.error "Unable to send via nodeMail: " + error.message
#             return
#           else
#             console.info "Sent an Email"
#           return

#       return

#     return

#   return

# exports.getToken = (req, user, callback) ->
#   verificationToken = new verificationTokenModel(_userId: req.user._id)
#   verificationToken.createVerificationToken (err, token) ->
#     if err
#       callback user
#     else
#       username = user.roomName
#       user.url = req.protocol + "://" + req.get("host") + "/visitor/" + username + "/" + token
#       callback user

#   return

# exports.sendVerification = (req, user, email) ->
#   instance = new createVerification(req, user, email)
#   info =
#     receiver: email
#     subject: "Confirmation Email - simple chat room"
#     textContent: "Please click the following link to verify your account"
#     htmlContent: "<p style='font-size:15px;'>Please click the following link to verify your account</p></br>"

#   instance.send info, "verify"
#   return

# exports.sendResetVerification = (req, user, email) ->
#   instance = new createVerification(req, user, email)
#   info =
#     receiver: email
#     subject: "Forgot password - simple chat room"
#     textContent: "Please click the following link to reset your password"
#     htmlContent: "<p style='font-size:15px;'>Please click the following link to reset your password</p></br>"

#   instance.send info, "reset"
#   return

# exports.verifyUser = (token, type, done) ->
#   verificationTokenModel.findOne
#     token: token
#   , (err, doc) ->
#     if err
#       done err
#     else unless doc
#       done err
#     else
#       User.findOne
#         _id: doc._userId
#       , (err, user) ->
#         if err
#           done err
        
#         # if user is not found
#         else unless user
#           done err
        
#         # if user is found
#         else
          
#           #if this module was called from
#           if type is "verify"
#             user.profile.confirmed = true
#             user.save (err) ->
#               if err
#                 done err
#               else
#                 console.log "The user has been verified"
#                 done null, user

#           else
#             done null, user
#         return

#     return

#   return