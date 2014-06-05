exports.loggerFormat = "dev"
exports.useErrorHandler = true
exports.enableEmailLogin = true
exports.mongodb = process.env.MONGO_DB || "mongodb://localhost/basic-bot"
exports.sessionSecret = "i am robot! a robot!"


#TODO: change these pins to your pins!
exports.motors = 
  a:
    dir: 23
    pow: 18
  b:
    dir: 22
    pow: 17
