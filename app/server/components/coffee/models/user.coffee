# mongoose = require("mongoose")
# bcrypt = require("bcrypt-nodejs")
# userSchema = mongoose.Schema(
#   profile:
#     username: String
#     email: String
#     gender: String
#     confirmed: Boolean
#     hasEmail: Boolean
#     primaryPhoto: String
#     photos:
#       local: String
#       facebook: String
#       twitter: String
#       google: String

#   local:
#     id: String
#     email: String
#     password: String

#   facebook:
#     id: String
#     token: String

#   twitter:
#     id: String
#     token: String
#     tokenSecret: String

#   google:
#     id: String
#     token: String
# )
# userSchema.methods.generateHash = (password) ->
#   bcrypt.hashSync password, bcrypt.genSaltSync(8), null

# userSchema.methods.validPassword = (password) ->
#   bcrypt.compareSync password, @local.password

# module.exports = mongoose.model("User", userSchema)