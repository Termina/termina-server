
var
  Pipeline $ require :cumulo-pipeline
  cp $ require :child_process
  fs $ require :fs

= exports.in $ new Pipeline
= exports.out $ new Pipeline

var register $ {}

exports.in.for $ \ (action)
  switch action.type
    :start
      var proc $ cp.exec action.data
      var command action.data
      = (. register proc.pid) proc
      exports.out.send $ {}
        :type :start
        :data $ {}
          :pid proc.pid
          :command command
          :directory (process.cwd)
      proc.on :exit $ \ (data)
        exports.out.send $ {}
          :type :stop
          :data $ {}
            :pid proc.pid

      proc.stdout.on :data $ \ (data)
        exports.out.send $ {}
          :type :stdout
          :data $ {}
            :pid proc.pid
            :text data

      proc.stderr.on :data $ \ (data)
        exports.out.send $ {}
          :type :stdout
          :data $ {}
            :pid proc.pid
            :text data

    :stop
      = proc $ . register action.data
      proc.kill
    :chdir
      if (fs.existsSync action.data)
        do
          process.chdir action.data
          exports.out.send action
    :join $ exports.out.send action
    :leave $ exports.out.send action
    :clear $ exports.out.send action

  return undefined
