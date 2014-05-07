(function() {
  var MongoStore, app, argv, auth, bodyParser, contents, cookieParser, cp, db, env, express, favicon, grunt, methodOverride, morgan, passport, path, port, prompt, repl, router, routes, session;

  express = require('express');

  session = require('express-session');

  MongoStore = require('connect-mongo')(session);

  path = require('path');

  routes = require('./routes');

  contents = require('./routes/contents');

  auth = require('./routes/auth');

  bodyParser = require('body-parser');

  favicon = require('static-favicon');

  methodOverride = require('method-override');

  morgan = require('morgan');

  passport = require('passport');

  cookieParser = require('cookie-parser');

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
    secret: "$noOnecanGetThisSecretBesidesZhengdianZhan",
    key: "express.sid",
    cookie: {
      path: '/',
      httpOnly: true,
      maxAge: new Date(Date.now() + (60000 * 60 * 24 * 365))
    },
    store: new MongoStore({
      mongoose_connection: db
    })
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

  app.route('/api/question').get(contents.loadQuestions).post(contents.makeQuestion);

  app.route('/api/findById/:id').get(contents.findById);

  app.route('/api/findByTerm/:searchTerm/:orderBy/:reversed/:offset').get(contents.findByTerm);

  app.route('/api/findByCategory/:category').get(contents.findByCategory);

  app.route('/api/filter').get(contents.loadFilters).post(contents.makeFilter);

  app.route('/api/filter/:searchTerm').get(contents.loadFilters);

  app.route('/api/auth').get(auth.index);

  app.listen(port, function() {
    return console.log('Express server listening on port ' + port);
  });

}).call(this);
