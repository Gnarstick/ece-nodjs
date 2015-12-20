levelup = require 'levelup'
levelws = require 'level-ws'
db = levelws levelup "#{__dirname}/../db/metric_user"

module.exports = 
  ###
  `get(kd, callbackb)`
  ------------------------
  get a user given a id

  Parameters:
  `id`: A String of the id
  `callback`: Callback function takes an error or null as parameter
  ###
  get: (id, callback) ->
    user = {username:""}
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      if data.key == id
        user.username = data.value
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, user

  ###
  `save(id, username, callbackb)`
  ------------------------
  save a user with a username

  Parameters:
  `id`: A String of the id
  `username`: A String of the username
  `callback`: Callback function takes an error or null as parameter
  ###
  save: (id, username, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "#{id}", value: "#{username}"
    ws.end()

  ###
  `remove(id, callbackb)`
  ------------------------
  remove a user given a username

  Parameters:
  `id`: A String of the id
  `callback`: Callback function takes an error or null as parameter
  ###
  remove: (id, callback) ->
    ws = db.createWriteStream({ type: 'del' })
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "#{id}"
    ws.end()

  ###
  `getmaxid(callbackb)`
  ------------------------
  get the max id of the database

  Parameters:
  `callback`: Callback function takes an error or null as parameter
  ###
  getmaxid: (callback) ->
    id = {}
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      id = data
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, id

  ###
  `getallid(callbackb)`
  ------------------------
  get an array of all the id inside the database

  Parameters:
  `callback`: Callback function takes an error or null as parameter
  ###
  getallid: (callback) ->
    id =  []
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      id.push(data.key)
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, id
    