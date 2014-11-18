
config  = require './config'
piblaster = require "pi-blaster.js"
fs      = require 'fs'
exec    = require('child_process').exec

stop = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 0)
    piblaster.setPwm(config.motors.a.enable2, 0)

    piblaster.setPwm(config.motors.b.enable1, 0)
    piblaster.setPwm(config.motors.b.enable2, 0)

forward = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 0)
    piblaster.setPwm(config.motors.a.enable2, 1.0)

    piblaster.setPwm(config.motors.b.enable1, 0)
    piblaster.setPwm(config.motors.b.enable2, 0.7)

backward = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 1.0)
    piblaster.setPwm(config.motors.a.enable2, 0)

    piblaster.setPwm(config.motors.b.enable1, 0.6)
    piblaster.setPwm(config.motors.b.enable2, 0)

left = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 0.6)
    piblaster.setPwm(config.motors.a.enable2, 0)

    piblaster.setPwm(config.motors.b.enable1, 0)
    piblaster.setPwm(config.motors.b.enable2, 0.6)

right = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 0)
    piblaster.setPwm(config.motors.a.enable2, 0.6)

    piblaster.setPwm(config.motors.b.enable1, 0.6)
    piblaster.setPwm(config.motors.b.enable2, 0)

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
      if data.length < 3795
        resetCount++
      if resetCount >= 5
        resetCount = 0
        #console.log "think the camera failed"
        exec "./resetWebCam", (err, stdout, stderr) ->
          console.log stdout
          console.error(stderr) if stderr?
          if err?
            return console.error stderr
          socket.emit "still", data.toString('base64')
      else
        resetCount = 0
      socket.emit "still", data.toString('base64')

  socket.on "disconnect", ->
    #console.log "disconnected"

  socket.on "up", (data) ->
    #socket.?emit "feedback", "and away"
    #console.log "up!"
    forward()

  socket.on "down", (data) ->
    #socket.?emit "feedback", "and out"
    #console.log "down!"
    backward()

  socket.on "left", (data) ->
    #socket.?emit "feedback", "loosey"
    #console.log "left!"
    left()

  socket.on "right", (data) ->
    #socket.?emit "feedback", "tighty"
    #console.log "right!"
    right()

  socket.on "stop", (data) ->
    #socket.?emit "feedback", "halt!"
    #console.log "stop!"
    stop()

