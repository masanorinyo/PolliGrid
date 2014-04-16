(function() {
  var app, bodyParser, cookieParser, cp, env, express, favicon, grunt, methodOverride, morgan, path, port, router, routes, session;

  express = require('express');

  path = require('path');

  routes = require('./routes');

  bodyParser = require('body-parser');

  favicon = require('static-favicon');

  methodOverride = require('method-override');

  morgan = require('morgan');

  session = require('express-sessions');

  cookieParser = require('cookie-parser');

  app = express();

  port = process.env.POR || 3000;

  router = express.Router();

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'jade');

  app.use(express["static"](path.join(__dirname, '../public')));

  app.use(favicon());

  app.use(bodyParser());

  app.use(bodyParser.json());

  app.use(bodyParser.urlencoded());

  app.use(methodOverride());

  app.use(cookieParser());

  env = process.env.NODE_ENV || 'development';

  if ('development' === env) {
    app.use(morgan('dev'));
    cp = require('child_process');
    grunt = cp.spawn('grunt', ['--force', 'default', 'watch']);
    grunt.stdout.on('data', function(data) {
      return console.log('%s', data);
    });
  }

  app.get('/', routes.index);

  app.listen(port, function() {
    return console.log('Express server listening on port ' + port);
  });

}).call(this);
