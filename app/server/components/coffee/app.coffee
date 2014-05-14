# ------------------------ modules  ------------------------ #

express           = require('express')
session           = require('express-session')
MongoStore        = require('connect-mongo')(session)
path              = require('path')
routes            = require('./routes')
contents          = require('./routes/contents')
bodyParser        = require('body-parser')
favicon           = require('static-favicon')
methodOverride    = require('method-override')
morgan            = require('morgan')
cookieParser      = require('cookie-parser') 

# ------------------------ passport config ------------------------ # 
passport       = require('passport')
require('./lib/passport')(passport)

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
app.route '/api/question/:questionId/:action'
      .get contents.findById
      .post contents.makeQuestion
      .put contents.favoriteQuestion

# returns contents
app.route '/api/findQuestions/:searchTerm/:category/:order/:offset'
      .get contents.findQuestions

# find questions by multiple ids
app.route "/api/findQuestionsAndFiltersByIds"
      .get contents.findQuestionsAndFiltersByIds

# update question
app.route '/api/updateQuestion/:questionId/:userId/:visitorId/:title/:filterId/:index/:task'
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

# authentication
require('./routes/auth')(app, passport)

# get user info
app.route '/api/getUser'
      .get contents.getUserInfo

# state transition from visitor to user
app.route '/api/visitorToGuest'
      .put contents.visitorToGuest

# update questions and filters answered
app.route '/api/updateUser/:userId/:qId/:qAnswer/:fId/:fAnswer/:task'
      .put contents.updateUser


# ------------------------ server setup ------------------------ #

app.listen(port,()->
      console.log 'Express server listening on port ' + port      
)