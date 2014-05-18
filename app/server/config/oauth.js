(function() {
  module.exports = {
    facebookAuth: {
      clientID: "1441817136066112",
      clientSecret: "cc1e351fd63f5ab68dd020ceb400c1eb",
      callbackURL: "http://localhost:3000/auth/facebook/callback",
      connectCallbackURL: "http://localhost:3000/connect/facebook/callback"
    },
    twitterAuth: {
      consumerKey: "Nb3QUO3hjbWbtmIZHaYDvrbo6",
      consumerSecret: "KK47AQIDZGrK7bULZxmvjQmuil04YU2bInuX82qUxwXiqohChm",
      callbackURL: "http://masa-chat.nodejitsu.com/auth/twitter/callback",
      connectCallbackURL: "http://masa-chat.nodejitsu.com/connect/twitter/callback"
    },
    googleAuth: {
      clientID: "846555084700-i8io0sdgtt54ioornq5vudld87t5dtge.apps.googleusercontent.com",
      clientSecret: "GrMFHIHH_sXjh7R0Lj2thuxG",
      callbackURL: "http://localhost:3000/auth/google/callback"
    }
  };

}).call(this);
