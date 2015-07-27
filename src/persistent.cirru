
var
  Immutable $ require :immutable
  Pipeline $ require :cumulo-pipeline
  fs $ require :fs

= exports.in $ new Pipeline

exports.in.for $ \ (db)
  var partDb $ ... db
    set :procs $ Immutable.List
    set :users $ Immutable.Map
    toJS

  fs.writeFile :db.json (JSON.stringify partDb) $ \ (err)
