# initial load 

exports.index  = (req, res)->
	res.render('index')

exports.uploadPhoto = (req,res)->
	console.log req
	console.log req.form
	console.log req.files
	console.log req.body.myObj
	console.log req.query.myObj

	
# 	fs.readFile(req.files.displayImage.path, function (err, data) {
#   // ...
#   var newPath = __dirname + "/uploads/uploadedFileName";
#   fs.writeFile(newPath, data, function (err) {
#     res.redirect("back");
#   });
# })