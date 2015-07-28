
var
  Immutable $ require :immutable
  Pipeline $ require :cumulo-pipeline
  fs $ require :fs
  path $ require :path

= exports.in $ new Pipeline

exports.in.for $ \ (db)
  var partDb $ ... db
    set :procs $ Immutable.List
    set :users $ Immutable.Map
    toJS

  var dbPath $ path.join __dirname :../db.json
  fs.writeFile dbPath (JSON.stringify partDb) $ \ (err)
