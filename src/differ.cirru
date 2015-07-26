
var
  Immutable $ require :immutable
  diff $ require :immutablediff
  Pipeline $ require :pipeline

= exports.in $ new Pipeline
= exports.out $ new Pipeline

var _cache $ Immutable.Map

exports.in.for $ \ (db)
  var
    theProcs $ db.get :procs
    theUsers $ db.get :users
  theUsers.forEach $ \ (id _)
    var _cachedView $ or
      . _cache id
      Immutable.Map
    if (isnt db _cachedView)
      do
        exports.out.send $ {}
          :type :diff
          :data $ diff _cachedView db
    return true
