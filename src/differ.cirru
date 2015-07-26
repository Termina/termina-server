
var
  Immutable $ require :immutable
  diff $ require :immutablediff
  Pipeline $ require :cumulo-pipeline

= exports.in $ new Pipeline
= exports.out $ new Pipeline

var _cache $ Immutable.Map

exports.in.for $ \ (db)
  var
    theProcs $ db.get :procs
    theUsers $ db.get :users
    newCache $ Immutable.Map
  theUsers.forEach $ \ (_ id)
    var cachedView $ or (_cache.get id) (Immutable.Map)
    if (isnt db cachedView)
      do
        exports.out.send $ {}
          :id id
          :diff $ diff cachedView db
    = newCache $ newCache.set id db
    return true
  = _cache newCache
