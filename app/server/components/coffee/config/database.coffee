mongoose = require('mongoose')

mongoose.connect('mongodb://masanorinyo:osaka777@ds049898.mongolab.com:49898/polligrid')
 
module.exports = mongoose.connection
