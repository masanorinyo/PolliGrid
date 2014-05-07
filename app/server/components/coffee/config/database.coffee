mongoose = require('mongoose')

mongoose.connect('mongodb://masanorinyo:osaka777@ds033477.mongolab.com:33477/whichone')
 
module.exports = mongoose.connection
