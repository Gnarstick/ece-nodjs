db = require('./db') "#{__dirname}/../db/user"

module.exports = 
  get: (username, callback) ->
    user = {}
    rs = db.createReadStream
      gte: "user:#{username}"
    rs.on 'data', (data) ->
      # parsing logic
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, user

  save: (username, password, name, email, callback) ->
    # save