
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
    now $ new Date
  case action.type
    :start
      db.set :procs $ theProcs.push $ ... schema.proc
        merge data
        merge $ Immutable.fromJS $ object
          :start-time (now.toISOString)
          :alive true
    :stop
      db.set :procs $ theProcs.map $ \ (proc)
        cond (is (proc.get :pid) (data.get :pid))
          proc.set :alive false
          , proc
    :delete
      db.set :procs $ theProcs.filter $ \ (proc)
        isnt (proc.get :pid) (data.get :pid)
    :stdout
      db.set :procs $ theProcs.map $ \ (proc)
        var stdout $ proc.get :stdout
        cond (is (proc.get :pid) (data.get :pid))
          proc.set :stdout $ stdout.push (data.get :text)
          , proc
    :stderr
      db.set :procs $ theProcs.map $ \ (proc)
        var stderr $ proc.get :stderr
        cond (is (proc.get :pid) (data.get :pid))
          proc.set :stderr $ stderr.push (data.get :text)
          , proc
    :join
      db.set :users $ theUsers.set (data.get :id)
        Immutable.Map
    :leave
      db.set :users $ theUsers.delete (data.get :id)
    else db
