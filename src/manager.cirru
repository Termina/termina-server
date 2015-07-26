
var
  Pipeline $ require :cumulo-pipeline
  cp $ require :child_process

= exports.in $ new Pipeline
= exports.out $ new Pipeline

var register $ {}

exports.in.for $ \ (action)
  switch action.type
    :start
      var proc $ cp.exec action.command
      console.info ":proc started " action.command
      = (. register proc.pid) proc
      exports.out.send $ {}
        :type :start
        :data $ {}
          :pid proc.pid
          :command action.command
          :directory action.directory
      proc.on :exit $ \ (data)
        console.info ":proc end " action.command
        exports.out.send $ {}
          :type :stop
          :data $ {}
            :pid proc.pid

      proc.stdout.on :data $ \ (data)
        console.info ":proc stdout " action.command (JSON.stringify data)
        exports.out.send $ {}
          :type :stdout
          :data $ {}
            :pid proc.pid
            :text data

      proc.stderr.on :data $ \ (data)
        console.info ":proc stderr " action.command data
        exports.out.send $ {}
          :type :stdout
          :data $ {}
            :pid proc.pid
            :text data

    :stop
      = proc $ . register action.pid
      proc.kill
    :delete $ exports.out.send action
    :join $ exports.out.send action
    :leave $ exports.out.send action

  return undefined
