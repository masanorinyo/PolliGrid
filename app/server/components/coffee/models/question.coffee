mongoose = require("mongoose")

questionSchema = mongoose.Schema(

    newOption           : String
    question            : String
    category            : String
    respondents         : []
    alreadyAnswered     : false
    numOfFavorites      : Number
    numOfFilters        : Number
    totalResponses      : Number
    created_at          : Number
    creator             : Number
    creatorName         : String
    photo               : String    
    option              : []
    targets             : []
)

module.exports = mongoose.model("Question", questionSchema)