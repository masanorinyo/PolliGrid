(function() {
  var MongoStore, app, argv, bodyParser, contents, cookieParser, cp, db, env, express, favicon, grunt, methodOverride, morgan, passport, path, port, prompt, repl, router, routes, session;

  express = require('express');

  session = require('express-session');

  MongoStore = require('connect-mongo')(session);

  path = require('path');

  routes = require('./routes');

  contents = require('./routes/contents');

  bodyParser = require('body-parser');

  favicon = require('static-favicon');

  methodOverride = require('method-override');

  morgan = require('morgan');

  cookieParser = require('cookie-parser');

  passport = require('passport');

  require('./lib/passport')(passport);

  argv = require('optimist').argv;

  repl = require('repl');

  db = require('./config/database');

  prompt = repl.start({
    prompt: 'whichone>'
  });

  app = express();

  port = process.env.POR || 3000;

  router = express.Router();

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'jade');

  app.use(express["static"](path.join(__dirname, '../public')));

  app.use(favicon(__dirname + '/../public/img/favicon.ico'));

  app.use(bodyParser());

  app.use(bodyParser.json());

  app.use(bodyParser.urlencoded());

  app.use(cookieParser());

  app.use(session({
    secret: "$noOnecanGetThisSecretBesidesZhengdianZhan"
  }));

  app.use(passport.initialize());

  app.use(passport.session());

  app.use(methodOverride());

  env = process.env.NODE_ENV || 'development';

  if ('development' === env) {
    app.use(morgan('dev'));
    cp = require('child_process');
    grunt = cp.spawn('grunt', ['--force', 'default', 'watch']);
    grunt.stdout.on('data', function(data) {
      return console.log('%s', data);
    });
  }

  app.route('/').get(routes.index);

  app.route('/api/question/:questionId/:action').get(contents.findById).post(contents.makeQuestion).put(contents.favoriteQuestion);

  app.route('/api/findQuestions/:searchTerm/:category/:order/:offset').get(contents.findQuestions);

  app.route('/api/updateQuestion/:questionId/:userId/:title/:filterId/:index/:task').put(contents.updateQuestion);

  app.route('/api/getQuestionTitle/:term/:category').get(contents.getQuestionTitle);

  app.route('/api/filter/:searchTerm/:offset').get(contents.loadFilters).post(contents.makeFilter);

  app.route('/api/getFilterTitle/:term').get(contents.getFilterTitle);

  require('./routes/auth')(app, passport);

  app.listen(port, function() {
    return console.log('Express server listening on port ' + port);
  });

}).call(this);
