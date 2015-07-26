
var
  Pipeline $ require :cumulo-pipeline
  cp $ require :child_process

= exports.in $ new Pipeline
= exports.out $ new Pipeline

var register $ {}

exports.in.for $ \ (action)
  switch action.type
    :start
      var proc $ cp.spawn action.bin action.args
      = (. register proc.pid) proc
      exports.out.send $ {}
        :type :start
        :data $ {}
          :pid proc.pid
          :command $ + action.bin ": " (action.args.join ": ")
          :directory action.directory
      proc.on :exit $ \ (data)
        exports.out.send $ {}
          :type :stop
          :data $ {}
            :pid proc.pid

      proc.stdout.on :data $ \ (data)
        exports.out.send $ {}
          :type :stdout
          :data $ {}
            :text data

      proc.stderr.on :data $ \ (data)
        exports.out.send $ {}
          :type :stdout
          :data $ {}
            :text data

    :stop
      = proc $ . register action.pid
      proc.kill
    :delete $ exports.out.send action
    :join $ exports.out.send action
    :leave $ exports.out.send action
