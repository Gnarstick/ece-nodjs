express = require 'express'
app = express()
metrics = require './metrics'

session = require 'express-session'
LevelStore = require('level-session-store') session
app.use session
	secret: 'MyAppSecret'
	store: new LevelStore './db/sessions' 
	resave: true
	saveUninitialized: true

app.set 'port', 1337
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"

app.listen app.get('port'), () ->
 console.log "server listening on #{app.get 'port'}"
		
app.get '/hello/:name', (req, res) ->
 res.send req.params.name
 
app.get '/test', (req, res) ->
 res.send "test"
 
app.get '/logout', (req, res) ->
 delete req.session.loggedIn
 delete req.session.username
 res.redirect '/login'
	
app.get '/login', (req, res) ->
 res.render 'login'
 
app.post '/signup', (req, res)->
  user.save req.body.username, req.body.password, req.body.email, req.body.name, (err)->
    if err then throw err
    console.log "save user #(req.body.username)"
    req.session.loggedIn = true
    req.session.username = req.body.username
    res.redirect '/login'
 
app.post '/login', (req,res) ->
  user.get req.body.username, (err,data) ->
    console.log req.body.password == data.password
    if err then throw err
    unless req.body.password == data.password
      res.redirect '/login'
    else
      req.session.loggedIn = true
      req.session.username = req.body.username
      res.redirect '/'

authCheck = (req, res, next) -> 
  unless req.session.loggedIn == true
    res.redirect '/login' 
  else
    next()
	
app.get '/', authCheck, (req, res)->
  res.render 'index', name: req.session.username
	  
app.get '/metrics.json', (req, res) ->
 res.status(200).json metrics.get()