(function() {
  exports.index = function(req, res) {
    return res.render('index');
  };

  exports.partials = function(req, res) {
    return res.render('partials/' + req.params.name);
  };

}).call(this);
