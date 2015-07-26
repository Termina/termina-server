
var
  ws $ require :ws
  Pipeline $ require :cumulo-pipeline
  shortid $ require :shortid

= exports.in $ new Pipeline
= exports.out $ new Pipeline

var register $ {}
exports.in.for $ \ (data)
  var ids $ Object.keys register
  ids.forEach $ \ (id)
    var socket $ . register id
    socket.send data

= exports.setup $ \ (options)

  var
    server $ new ws.WebSocketServer $ {} (:port options.port)

  server.on :connection $ \ (socket)

    var id (shortid.generate)
    = (. register id) socket
    exports.out.send $ {}
      :type :join
      :data $ {} (:id id)

    socket.on :close $ \ ()
      delete (. register id)
      exports.out.send $ {}
        :type :leave
        :data $ {} (:id id)

    socket.on :message $ \ (raw)
      var data $ JSON.parse raw
      exports.out.send data
