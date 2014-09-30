
config  = require './config'
piblaster = require "pi-blaster.js"
fs      = require 'fs'
exec    = require('child_process').exec

stop = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.pow, 0)
    piblaster.setPwm(config.motors.a.dir, 0)
    piblaster.setPwm(config.motors.b.pow, 0)
    piblaster.setPwm(config.motors.b.dir, 0)

backward = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.pow, 1.0)
    piblaster.setPwm(config.motors.a.dir, 0)
    piblaster.setPwm(config.motors.b.pow, 1.0)
    piblaster.setPwm(config.motors.b.dir, 0)

forward = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.pow, 0)
    piblaster.setPwm(config.motors.a.dir, 0.9)
    piblaster.setPwm(config.motors.b.pow, 0)
    piblaster.setPwm(config.motors.b.dir, 1.0)

left = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.pow, 0)
    piblaster.setPwm(config.motors.a.dir, 0.6)
    piblaster.setPwm(config.motors.b.pow, 0.6)
    piblaster.setPwm(config.motors.b.dir, 0)

right = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.pow, 0.6)
    piblaster.setPwm(config.motors.a.dir, 0)
    piblaster.setPwm(config.motors.b.pow, 0)
    piblaster.setPwm(config.motors.b.dir, 0.6)

module.exports = (socket) ->

  if config.isPI
    stop()

  # listen for different socket events
  #socket.?emit "feedback", "I am your father"
  
  socket.on "getImage", (msg)->
    process.nextTick sendImage

  resetCount = 0
  sendImage = ->
    fs.readFile './public/motion/stil.jpg', (err, data) ->
      #if data.length < 3795 && data.length > 3970
      #  resetCount++
      #if resetCount >= 5
      #  resetCount = 0
      #  #console.log "think the camera failed"
      #  exec "./resetWebCam", (err, stdout, stderr) ->
      #    console.log stdout
      #    console.error(stderr) if stderr?
      #    if err?
      #      return console.error stderr
      #    socket.emit "still", data.toString('base64')
      #else
      #  resetCount = 0
      socket.emit "still", data.toString('base64')

  socket.on "disconnect", ->
    console.log "disconnected"

  socket.on "up", (data) ->
    #socket.?emit "feedback", "and away"
    forward()
    console.log "up!"

  socket.on "down", (data) ->
    #socket.?emit "feedback", "and out"
    backward()
    console.log "down!"

  socket.on "left", (data) ->
    #socket.?emit "feedback", "loosey"
    left()
    console.log "left!"

  socket.on "right", (data) ->
    #socket.?emit "feedback", "tighty"
    right()
    console.log "right!"

  socket.on "stop", (data) ->
    #socket.?emit "feedback", "halt!"
    stop()
    console.log "stop!"

