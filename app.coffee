###
Module dependencies.
###
config          = require './config'
express         = require 'express'
path            = require 'path'
http            = require 'http'
socketIo        = require "socket.io"
path            = require 'path'
#mongoose        = require 'mongoose'
_               = require 'underscore'
#passport        = require 'passport'
#User            = require('./models').User

#MongoStore = require('connect-mongo')(express)
#sessionStore = new MongoStore({ url: config.mongodb })

#LocalStrategy = require('passport-local').Strategy

#passport.use "email", new LocalStrategy
    #usernameField: "email"
  #, (email, password, done) ->
    #process.nextTick ->
      #User.authEmail email, password, done

#passport.serializeUser (user, done) ->
  #done null, user.id

#passport.deserializeUser (id, done) ->
  #User.findById id, (err, user) ->
    #done err, user


# connect the database
#mongoose.connect config.mongodb

# create app, server, and web sockets
app = express()
server = http.createServer(app)
io = socketIo.listen(server)

# Make socket.io a little quieter
io.set "log level", 1

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"

  # use the connect assets middleware for Snockets sugar
  app.use require("connect-assets")()
  app.use express.logger(config.loggerFormat)
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser config.sessionSecret
  #app.use express.session store: sessionStore
  #app.use passport.initialize()
  #app.use passport.session()
  app.use app.router
  app.use express.static path.join(__dirname, "assets")
  app.use express.static path.join(__dirname, "public")
  app.use express.errorHandler()  if config.useErrorHandler

require('./urls') app


io.sockets.on "connection",  (socket) ->
  require('./gpio') socket

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

