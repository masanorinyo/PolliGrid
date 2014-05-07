# mongoose = require("mongoose")
# uuid = require("node-uuid")
# User = require("./user")

# # Verification token model
# verificationTokenSchema = mongoose.Schema(
#   _userId:
#     type: String
#     required: true
#     ref: "User"

#   token:
#     type: String
#     required: true

#   createdAt:
#     type: Date
#     required: true
#     default: Date.now
#     expires: "4h"
# )
# verificationTokenSchema.methods.createVerificationToken = (done) ->
#   verificationToken = this
#   token = uuid.v4()
#   verificationToken.set "token", token
#   verificationToken.save (err) ->
#     if err
#       done err
#     else
#       return done(null, token)
#       console.log "Verification token", verificationToken
#     return

#   return

# module.exports = mongoose.model("VerificationToken", verificationTokenSchema)