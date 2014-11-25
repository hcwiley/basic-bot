
config  = require './config'
piblaster = require "pi-blaster.js"
fs      = require 'fs'
exec    = require('child_process').exec

pwmPower = 0.75

stop = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 0)
    piblaster.setPwm(config.motors.a.enable2, 0)

    piblaster.setPwm(config.motors.b.enable1, 0)
    piblaster.setPwm(config.motors.b.enable2, 0)

forward = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 0)
    piblaster.setPwm(config.motors.a.enable2, pwmPower)

    piblaster.setPwm(config.motors.b.enable1, 0)
    piblaster.setPwm(config.motors.b.enable2, pwmPower)

backward = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, pwmPower)
    piblaster.setPwm(config.motors.a.enable2, 0)

    piblaster.setPwm(config.motors.b.enable1, pwmPower)
    piblaster.setPwm(config.motors.b.enable2, 0)

left = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, pwmPower)
    piblaster.setPwm(config.motors.a.enable2, 0)

    piblaster.setPwm(config.motors.b.enable1, 0)
    piblaster.setPwm(config.motors.b.enable2, pwmPower)

right = ->
  if config.isPI
    piblaster.setPwm(config.motors.a.enable1, 0)
    piblaster.setPwm(config.motors.a.enable2, pwmPower)

    piblaster.setPwm(config.motors.b.enable1, pwmPower)
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
      if data.length < 3195 && data.length > 3150
        resetCount++
      else
        resetCount = 0
      if resetCount >= 15
        resetCount = 0
        #console.log "think the camera failed"
        exec "./resetWebCam", (err, stdout, stderr) ->
          console.log stdout
          console.error(stderr) if stderr?
          if err?
            return console.error stderr
          socket.emit "still", data.toString('base64')
      else
        socket.emit "still", data.toString('base64')

  socket.on "disconnect", ->
    #console.log "disconnected"

  socket.on "pwmPower", (data) ->
    console.log "updating pwmPower: #{data}"
    pwmPower = data

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

