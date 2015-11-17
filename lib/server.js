var http = require('http');
var users = require('./users.js');

http.createServer(function (req, res) {
	
	var path = req.url.split("/")
	
	if (path[1] == "get")
	{
	users.get(path[2], function (user) {
		var response = {
			info: "here's your user !",
			user: user
		}
	res.writeHead(200, {content: 'application/json'});
	res.end(JSON.stringify(response));
	})
	}
	else if (path[1] == "save")
	{
	users.save(path[2], function (user) {
		var response = {
			info: "user save !",
			user: user
		}
	res.writeHead(200, {content: 'application/json'});
	res.end(JSON.stringify(response));
	})
	}
	else
	{
	res.writeHead(200, {content: 'application/json'});
	res.end("error");
	
	}
	
}).listen(1337, '127.0.0.1');