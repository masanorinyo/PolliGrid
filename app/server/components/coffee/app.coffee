# ------------------------ modules  ------------------------ #

express           = require('express')
session           = require('express-session')
MongoStore        = require('connect-mongo')(session)
path              = require('path')
routes            = require('./routes')
contents          = require('./routes/contents')
auth              = require('./routes/auth')
bodyParser        = require('body-parser')
favicon           = require('static-favicon')
methodOverride    = require('method-override')
morgan            = require('morgan')
passport          = require('passport')
cookieParser      = require('cookie-parser') 


# ------------------------ server config ------------------------ #

argv              = require('optimist').argv
repl              = require('repl')
db                = require('./config/database')
prompt            = repl.start({ prompt:'whichone>'})

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
      
app.use(favicon(__dirname + '/../public/img/favicon.ico'))


# pull info from html #

app.use(bodyParser())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded())

# cookie & session management #
app.use(cookieParser())
app.use(session( 
            secret : "$noOnecanGetThisSecretBesidesZhengdianZhan",
            key    : "express.sid"
            cookie : {
                  path        : '/'
                  httpOnly    : true
                  maxAge      : new Date(Date.now()+(60000*60*24*365))
            }
            store  : new MongoStore({mongoose_connection:db}) 
      )
)

# passport initial configuration
app.use(passport.initialize())
app.use(passport.session())

# simulate DELETE and PUT #
app.use(methodOverride())


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

#################################################
# ----------------- Overall ------------------- #
#################################################

app.route '/'
      .get routes.index

#################################################
# -------------- Question handlers ------------ #
#################################################

# returns user related contents
app.route '/api/question/:questionId'
      .get contents.findById
      .post contents.makeQuestion

# returns contents
app.route '/api/findQuestions/:searchTerm/:category/:order/:offset'
      .get contents.findQuestions

# update question
app.route '/api/updateQuestion/:questionId/:userId/:title/:filterId/:optionId'
      .put contents.updateQuestion


# returns typehead data
app.route '/api/getQuestionTitle/:term/:category'
      .get contents.getQuestionTitle

#################################################
# -------------- Filter handlers -------------- #
#################################################

# get filters
app.route '/api/filter/:searchTerm/:offset'
      .get contents.loadFilters
      .post contents.makeFilter

# returns typehead data
app.route '/api/getFilterTitle/:term'
      .get contents.getFilterTitle

#################################################
# -------------- User handlers ---------------- #
#################################################

app.route '/api/auth'
      .get auth.index


# ------------------------ server setup ------------------------ #

app.listen(port,()->
      console.log 'Express server listening on port ' + port      
)