var allTestFiles = [];
var TEST_REGEXP = /(spec|test)\.js$/i;

Object.keys(window.__karma__.files).forEach(function(file) {
  if (TEST_REGEXP.test(file)) {
    // Normalize paths to RequireJS module names.
    console.log(file);
    allTestFiles.push(file);
    
  }
});

require.config({
  
  // Karma serves files under /base, which is the basePath from your config file
  baseUrl: '/base/app/public/js',

  paths:{
    'angular'             : '/base/app/public/vendors/angular/angular',
    'angularMocks'        : '/base/app/public/vendors/angular-mocks/angular-mocks',
    "angularRoute"        : "/base/app/public/vendors/angular-route/angular-route.min",
    "angularResource"     : "/base/app/public/vendors/angular-resource/angular-resource.min",
    "angularCookies"      : "/base/app/public/vendors/angular-cookies/angular-cookies.min",
    "angularSanitize"     : "/base/app/public/vendors/angular-sanitize/angular-sanitize.min",   
    "angularLocalStorage" : "/base/app/public/vendors/angular-local-storage/angular-local-storage.min",
    "angularUiRouter"     : "/base/app/public/vendors/angular-ui-router/release/angular-ui-router.min",
    "jquery"              : "/base/app/public/vendors/jquery/dist/jquery.min",
    "angular-bootstrap"   : "/base/app/public/vendors/angular-bootstrap/ui-bootstrap-tpls.min"
    "domReady"            : "/base/app/public/vendors/requirejs-domready/domready",
    "underscore"          : "/base/app/public/vendors/underscore/underscore"
  },

  shim: {
    
    "angular"             :
      {'exports'          : 'angular'},

    "angularMocks"        : 
      {
        deps              : ['angular'],
        'exports'         : 'angular.mock'
      },

    "angularRoute"        : 
      {deps               : ['angular']},

    "angularResource"     :
      {deps               : ['angular']},

    "angularCookies"      : 
      {deps               : ['angular']},

    "angularSanitize"     : 
      {deps               : ['angular']},

    "angularLocalStorage" : 
      {deps               : ['angular']},

    "angularUiRouter"     : 
      {deps               : ['angular']},

    "angular-bootstrap"     : 
      {deps               : ['angular']},

    "jquery"              : 
      {exports            : '$'},


    "underscore"          :
      {exports            : '_'}
  },

  // dynamically load all test files
  deps: allTestFiles,

  // we have to kickoff jasmine, as it is asynchronous
  callback: window.__karma__.start
});
