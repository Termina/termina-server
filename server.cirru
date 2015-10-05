
var
  database $ require :./src/database
  manager $ require :./src/manager
  websocket $ require :./src/websocket
  differ $ require :./src/differ
  persistent $ require :./src/persistent

websocket.setup $ {}
  :port 4006

websocket.out.forward manager.in
manager.out.forward database.in
database.out.forward differ.in
differ.out.forward websocket.in

database.out.forward persistent.in

console.log ":ws server started"
