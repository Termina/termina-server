
var
  ws $ require :ws
  Pipeline $ require :cumulo-pipeline
  shortid $ require :shortid

= exports.in $ new Pipeline
= exports.out $ new Pipeline

var register $ {}
exports.in.for $ \ (data)
  var socket $ . register data.id
  socket.send $ JSON.stringify data.diff

= exports.setup $ \ (options)

  var
    server $ new ws.Server $ {} (:port options.port)

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
