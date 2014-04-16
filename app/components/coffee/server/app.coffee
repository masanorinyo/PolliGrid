# ------------------------ modules  ------------------------ #

express           = require('express')
path              = require('path')
routes            = require('./routes')
bodyParser        = require('body-parser')
favicon           = require('static-favicon')
methodOverride    = require('method-override')
morgan            = require('morgan')
session           = require('express-sessions')
cookieParser      = require('cookie-parser') 


# ------------------------ express setting ------------------------ #

app               = express()
port              = process.env.POR || 3000
router            = express.Router()

# ------------------------ environment setting ------------------------ #

# template engine #

app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')


# static directories #

app.use(express.static(path.join(__dirname, '../public'))) 


# hale to favicon #
      
app.use(favicon())


# pull info from html #

app.use(bodyParser())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded())


# simulate DELETE and PUT #
app.use(methodOverride())


# cookie & session management #
app.use(cookieParser())
# app.use(express.session())


# -------------- development only - flirts with grunt --------------#
env = process.env.NODE_ENV || 'development'
if 'development' is env

      # log every request #

      app.use(morgan('dev'))
      

      #grunt configuration
      
      cp = require('child_process')
      grunt = cp.spawn('grunt', [
            '--force'
            'default'
            'watch'
      ])
      
      grunt.stdout.on 'data', (data) ->
            #relay output to console
            console.log '%s', data
    

# ------------------------ express router ------------------------ #

app.get '/', routes.index


# ------------------------ server setup ------------------------ #

app.listen(port,()->
      console.log 'Express server listening on port ' + port      
)