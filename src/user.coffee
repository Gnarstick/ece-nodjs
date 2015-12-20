levelup = require 'levelup'
levelws = require 'level-ws'
db = levelws levelup "#{__dirname}/../db/user"

module.exports = 
  get: (username, callback) ->
    user = {username:"", password:"", email:"", name:""}
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      usertemp = data.key.split ":"
      if usertemp[1] == username
        usern=data.key.split ":"
        datan=data.value.split ","
        user.username=usern[1]
        user.password=datan[0]
        user.email=datan[1]
        user.name=datan[2]
    rs.on 'error', callback 
    rs.on 'close', ->
      console.log user
      callback null, user

  save: (username, password, email, name, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{username}", value: "#{password},#{name},#{email}"
    ws.end()

  remove: (username, callback) ->
    ws = db.createWriteStream({ type: 'del' })
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{username}"
    ws.end()
  