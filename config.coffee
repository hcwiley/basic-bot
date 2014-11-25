
exec = require("child_process").exec

exports.loggerFormat = "dev"
exports.useErrorHandler = true
exports.enableEmailLogin = true
exports.mongodb = process.env.MONGO_DB || "mongodb://localhost/basic-bot"
exports.sessionSecret = "i am robot! a robot!"

exports.isPI = false

child = exec "uname -m", (error, stdout, stderr) ->
  # if the system is an arm chip we are going to assume its a pi
  console.log stdout.match 'arm'
  if stdout.match 'arm'
    console.log 'its a PI!'
    exports.isPI = true

#TODO: change these pins to your pins!
exports.motors = 
  a:
    enable1: 24
    enable2: 18
  b:
    enable1: 22
    enable2: 17
