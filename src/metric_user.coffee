levelup = require 'levelup'
levelws = require 'level-ws'
db = levelws levelup "#{__dirname}/../db/metric_user"

module.exports = 
  get: (id, callback) ->
    user = {username:""}
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      if data.key == id
        user.username = data.value
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, user

  save: (id, username, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "#{id}", value: "#{username}"
    ws.end()

  remove: (id, callback) ->
    ws = db.createWriteStream({ type: 'del' })
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "#{id}"
    ws.end()

  getmaxid: (callback) ->
    id = {}
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      id = data
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, id

  getallid: (callback) ->
    id =  []
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      id.push(data.key)
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, id
    