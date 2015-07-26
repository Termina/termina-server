
var
  Pipeline $ require :cumulo-pipeline
  Immutable $ require :immutable
  shortid $ require :shortid
  schema $ require :./schema

= exports.in $ new Pipeline

var initial $ Immutable.fromJS $ {}
  :users $ {}
  :procs $ []

= exports.out $ exports.in.reduce initial $ \ (db action)
  var
    data $ Immutable.fromJS action.data
    theProcs $ db.get :procs
    theUsers $ db.get :users
  switch action.type
    :start
      var now $ new Date
      return $ db.set :procs $ theProcs.push $ data.merge $ Immutable.fromJS $ object
        :start-time (now.toISOString)
        :alive true
    :stop
      return $ db.set :procs $ map $ \ (proc)
        return $ cond (is (proc.get :pid) (data.get :id))
          proc.set :alive false
          , proc
    :delete
      return $ db.set :procs $ theProcs.filter $ \ (proc)
        return $ isnt (proc.get :pid) (data.get :pid)
    :stdout
      return $ db.set :procs $ theProcs.map $ \ (proc)
        var stdout $ proc.get :stdout
        return $ cond (is (proc.get :pid) (data.get :pid))
          prop.set :stdout $ stdout.push data.text
          , proc
    :stderr
      return $ db.set :procs $ theProcs.map $ \ (proc)
        var stderr $ proc.get :stderr
        return $ cond (is (proc.get :pid) (data.get :pid))
          prop.set :stderr $ stderr.push data.text
          , proc
    :join
      return $ db.set :users $ theUsers.set (data.get :id)
        Immutable.map
    :leave
      return $ db.set :users $ theUsers.delete (data.get :id)
    else
      return db
