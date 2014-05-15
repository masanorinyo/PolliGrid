(function() {
  exports.index = function(req, res) {
    return res.render('index');
  };

  exports.uploadPhoto = function(req, res) {
    console.log(req);
    console.log(req.form);
    console.log(req.files);
    console.log(req.body.myObj);
    return console.log(req.query.myObj);
  };

}).call(this);
