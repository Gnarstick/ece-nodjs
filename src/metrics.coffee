db = require('./db') "#{__dirname}/../db/metrics"

module.exports =
  ###
  `get()`
  ------

  Returns some hard coded metrics
  ###
  get: (id, callback) ->
    user = []
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      datatemp = data.key.split ":"
      if datatemp[1] == id
        user.push({timestamp:datatemp[2], value:data.value})
    rs.on 'error', callback 
    rs.on 'close', ->
      callback null, user
    

  ###
  `save(id, metrics, cb)`
  ------------------------
  Save some metrics with a given id

  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: An objects with a timestamp and a value
  `callback`: Callback function takes an error or null as parameter
  ###
  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "metric:#{id}:"+metrics.timestamp, value: metrics.value
    ws.end()

  ###
  `remove(id, time, callback)`
  ---------------------------
  remove a metric
  
  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: A timestamp
  `callback`: Callback function takes an error or null as parameter
  ###
  remove: (id, time, callback) ->
    ws = db.createWriteStream({ type: 'del' })
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "metric:#{id}:#{time}"
    ws.end()
	