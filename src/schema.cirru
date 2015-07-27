
var
  Immutable $ require :immutable

= exports.proc $ Immutable.fromJS $ {}
  :pid null
  :command null
  :directory null
  :start-time null
  :alive false
  :stdout $ []
  :stderr $ []

= exports.db $ Immutable.fromJS $ {}
  :procs $ []
  :users $ {}
  :directories $ {}
  :commands $ {}
  :cwd (process.cwd)
