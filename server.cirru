
var
  database $ require :./src/database
  manager $ require :./src/manager
  websocket $ require :./src/websocket
  differ $ require :./src/differ

websocket.setup $ {}
  :port 3000

websocket.out.forward manager.in
manager.out.forward database.in
database.out.forward differ.in
differ.out.forward websocket.in

database.out.for $ \ (db)
  console.log :db ": " (JSON.stringify db)
console.log ":ws server started"
