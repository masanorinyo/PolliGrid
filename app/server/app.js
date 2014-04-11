(function() {
  var app, cp, express, grunt, http, path, routes;

  express = require('express');

  routes = require('./routes');

  http = require('http');

  path = require('path');

  app = express();

  app.set('port', process.env.PORT || 3000);

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'jade');

  app.use(express.favicon());

  app.use(express.logger('dev'));

  app.use(express.json());

  app.use(express.urlencoded());

  app.use(express.methodOverride());

  app.use(app.router);

  app.use(express["static"](path.join(__dirname, '../public')));

  if ('development' === app.get('env')) {
    app.use(express.errorHandler());
    cp = require('child_process');
    grunt = cp.spawn('grunt', ['--force', 'default', 'watch']);
    grunt.stdout.on('data', function(data) {
      return console.log('%s', data);
    });
  }

  app.get('/', routes.index);

  http.createServer(app).listen(app.get('port'), function() {
    return console.log('Express server listening on port ' + app.get('port'));
  });

}).call(this);
