
'''
config    = require './config'
mongoose  = require 'mongoose'
fs        = require 'fs'
Schema    = mongoose.Schema
Mixed     = Schema.Types.Mixed
bcrypt    = require('bcrypt')

User = new Schema
  name: String
  email:
    type: String
    required: true
    unique: true
  is_admin:
    type: Boolean
    default: false
  salt: String
  hash: String

User.method

User.virtual("password").get(->
    @_password
  ).set (password) ->
    @_password = password
    salt = @salt = bcrypt.genSaltSync(10)
    @hash = bcrypt.hashSync(password, salt)

User.method "checkPassword", (password, callback) ->
  bcrypt.compare password, @hash, callback

User.static "registerEmail", (email, password, passwordConfirm, callback) ->
  return callback("PASSWORD_MISMATCH", false)  unless password is passwordConfirm
  user = new exports.User
    email: email
    password: password
  user.save callback

User.static "authEmail", (email, password, callback) ->
  exports.User.findOne email: email, (err, user) ->
    return callback(err)  if err
    return callback(null, false)  unless user
    user.checkPassword password, (err, isCorrect) ->
      return callback(err)  if err
      return callback(null, false)  unless isCorrect
      callback null, user

exports.User = mongoose.model 'User', User
'''
