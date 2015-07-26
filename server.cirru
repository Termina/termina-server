
var
  database $ require :./src/database
  manager $ require :./src/manager
  websocket $ require :./src/websocket
  differ $ require :./src/differ

websocket.setup $ {}
  :port 3000

websocket.forward manager
manager.forward database
database.forward differ
differ.forward websocket
