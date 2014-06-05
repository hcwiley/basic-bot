
config          = require '../config'
passport        = require 'passport'
User            = require('../models').User

exports.signin = (req, res) ->
  if req.user
    res.redirect '/profile'
  else
    res.render 'auth/signin'

exports.email = passport.authenticate "email",
  successRedirect: "/auth/success"
  failureRedirect: "/auth/failure"
  failureFlash: true

exports.registerEmail = (req, res) ->
  console.log "REGISTERING VIA EMAIL!"
  User.registerEmail req.body.email, req.body.password, req.body.passwordConfirm, (err, user) ->
    return res.render('error', err:err)  if err
    exports.email req, res

exports.logout = (req, res) ->
  req.logout()
  res.send 200

exports.success = (req, res) ->
  res.redirect '/'

exports.failure = (req, res) ->
  console.log 'failed'
  res.redirect '/auth/signin'
