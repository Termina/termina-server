
var
  database $ require :./database
  manager $ require :./manager
  websocket $ require :./websocket
  differ $ require :./differ
  persistent $ require :./persistent

websocket.setup $ {}
  :port 4006

websocket.out.forward manager.in
manager.out.forward database.in
database.out.forward differ.in
differ.out.forward websocket.in

database.out.forward persistent.in

console.log ":listening at localhost: 4006 , visit this page:"
console.log ":http://repo.tiye.me/Cumulo/termina-app/?domain=localhost"
