express = require 'express'
app = express()
stylus = require 'stylus'
metrics = require './metrics'
user = require './user'
metrics_user = require './metric_user'

bodyParser = require 'body-parser'
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
app.use stylus.middleware "#{__dirname}/../public"
app.use '/', express.static "#{__dirname}/../public"
app.use bodyParser()

app.listen app.get('port'), () ->
 console.log "server listening on #{app.get 'port'}"

###
Logout route
### 
app.get '/logout', (req, res) ->
 delete req.session.loggedIn
 delete req.session.username
 res.redirect '/login'
	
app.get '/login', (req, res) ->
 res.render 'login'
 
app.get '/signup', (req, res) ->
 res.render 'signup'
 
app.post '/signup', (req, res)->
  user.save req.body.username, req.body.password, req.body.email, req.body.name, (err) ->
    if err then throw err
    req.session.loggedIn = true
    req.session.username = req.body.username
    res.redirect '/'
 
app.post '/login', (req,res) ->
  user.get req.body.username, (err,data) ->
    if err then throw err
    if req.body.username != ""
      unless req.body.password == data.password
        res.redirect '/login'
      else
        req.session.loggedIn = true
        req.session.username = req.body.username
        res.redirect '/'
    else
      res.redirect '/login'

app.post '/', (req, res) ->
 date = new Date().getTime()
 arr = {timestamp: date, value: req.body.value}
 metrics.save req.body.id, arr, (err) ->
  res.redirect '/'

###
authCheck fonction
### 
authCheck = (req, res, next) -> 
  unless req.session.loggedIn == true
    res.redirect '/login' 
  else
    next()

###
Index with identification check
### 
app.get '/', authCheck, (req, res)->
  metrics_user.getallid (err, data)->
    res.render 'index', {name: req.session.username, metric_user: data}
	  
app.get '/metrics.json/:id', (req, res) ->
 metrics.get req.params.id, (err, data) ->
   res.status(200).json data

app.get '/metric_user.json/:id', (req, res) ->
 metrics_user.get req.params.id, (err, data) ->
   res.status(200).json data
   
app.get '/delete-metric/:id/:timestamp', (req, res) ->
 metrics.remove req.params.id, req.params.timestamp, (err) ->
   res.redirect '/'

app.get '/delete-groupe/:id', (req, res) ->
 metrics_user.getallid (err, data) ->
   for metric in data
     metrics.remove req.params.id, metric.timestamp, (err) ->
   metrics_user.remove req.params.id, (err) ->
     res.redirect '/'

app.get '/add-groupe', (req, res) ->
  metrics_user.getmaxid (err, data) ->
    if err then throw err
    if isNaN(data.key)
      metrics_user.save 1, req.session.username, (err) ->
        res.redirect '/'
    else
      metrics_user.save +data.key+1, req.session.username, (err) ->
        res.redirect '/'