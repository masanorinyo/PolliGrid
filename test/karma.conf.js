// Karma configuration
// Generated on Tue Apr 08 2014 20:51:21 GMT-0400 (EDT)

module.exports = function(config) {
  config.set({
    
    
    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '../',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine', 'requirejs'],


    // list of files / patterns to load in the browser
    files: [
      {pattern: 'app/components/coffee/public/*.coffee', included: false},
      {pattern: 'app/components/coffee/public/**/*.coffee', included: false},
      {pattern: 'test/unit/**/**/*.coffee', included: false},
      {pattern: 'test/unit/**/*.coffee', included: false},
      {pattern: 'app/public/js/**/*.js', included: false},
      {pattern: 'app/public/js/*.js', included: false},
      {pattern: 'app/public/vendors/**/*.js', included: false},
      {pattern: 'app/public/vendors/**/**/*.js', included: false},
      'test/test-main.js'
    ],


    // list of files to exclude
    exclude: [
      "app/public/js/main.js",
      "app/public/js/misc/*.js"
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'test/**/*.coffee': ['coffee']
    
    },

    coffeePreprocessor: {
      // options passed to the coffee compiler
      options: {
        bare: true,
        sourceMap: false
      },
      // transforming the filenames
      transformPath: function(path) {
        return path.replace(/\.coffee$/, '.js');
      }
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['ChromeCanary'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false
  });
};
