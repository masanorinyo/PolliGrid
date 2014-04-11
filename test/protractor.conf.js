exports.config = {
  allScriptsTimeout: 5000,

  specs: [
    'e2e/**/*Spec.js'
  ],

  capabilities: {
    'browserName': 'ChromeCanary'
  },

  baseUrl: 'http://localhost:3000',

  framework: 'jasmine',

};
