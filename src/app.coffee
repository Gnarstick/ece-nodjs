express = require 'express'
app = express()
metrics = require './metrics'

app.set 'port', 1337
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'
app.use '/', express.static "#{__dirname}/../public"

app.listen app.get('port'), () ->
 console.log "server listening on #{app.get 'port'}"
 
app.get '/', (req, res) ->
  res.render 'index',
    locals:
      title: 'My ECE test page'
		
app.get '/hello/:name', (req, res) ->
 res.send req.params.name
 
app.get '/test', (req, res) ->
 res.send "test"
 
app.get '/metrics.json', (req, res) ->
 res.status(200).json metrics.get()