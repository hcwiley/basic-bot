
exec = require("child_process").exec

exports.loggerFormat = "dev"
exports.useErrorHandler = true
exports.enableEmailLogin = true
exports.mongodb = process.env.MONGO_DB || "mongodb://localhost/basic-bot"
exports.sessionSecret = "i am robot! a robot!"

exports.isPI = false

child = exec "uname -m", (error, stdout, stderr) ->
  if stdout == 'armv6l'
    exports.isPI = true

#TODO: change these pins to your pins!
exports.motors = 
  a:
    dir: 23
    pow: 18
  b:
    dir: 22
    pow: 17
