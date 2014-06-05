
config      = require './config'
_           = require 'underscore'
#routes      = {}
#routes.auth = require './routes/auth'

module.exports = (app) ->
  app.get '*', (req, res, next) ->
    req.args = {}
    req.args.user = false
    #if req.user
      #req.args['user'] = req.user
    #else if req.url != '/auth/signin'
      #return res.redirect '/auth/signin'
    next()

  app.get '/', (req, res) ->
    res.render 'index', req.args

  #app.get '/profile', (req, res) ->
    #res.render 'me/index', req.args

  #app.put '/profile', (req, res) ->
    #req.user.name = req.body.name
    #req.user.email = req.body.email
    #req.user.save (err, user) ->
      #res.redirect '/profile'

  #user auth stuff
  #app.get '/auth/signin', routes.auth.signin
  #app.post '/auth/registerEmail', routes.auth.registerEmail
  #app.post '/auth/email', routes.auth.email
  #app.get "/auth/success", routes.auth.success
  #app.get "/auth/failure", routes.auth.failure
  #app.get "/auth/logout", routes.auth.logout
