
gpio    = require 'gpio'
config  = require './config'

stop = ->
  if config.isPI
    pins[config.motors.a.pow].reset()
    pins[config.motors.a.dir].reset()
    pins[config.motors.b.pow].reset()
    pins[config.motors.b.dir].reset()

forward = ->
  if config.isPI
    # set motor a to forward
    pins[config.motors.a.pow].set()
    pins[config.motors.a.dir].set(0)
    pins[config.motors.b.pow].set()
    pins[config.motors.b.dir].set(0)

backward = ->
  if config.isPI
    pins[config.motors.a.pow].set(0)
    pins[config.motors.a.dir].set()
    pins[config.motors.b.pow].set(0)
    pins[config.motors.b.dir].set()

left = ->
  if config.isPI
    pins[config.motors.a.pow].set(0)
    pins[config.motors.a.dir].set()
    pins[config.motors.b.pow].set()
    pins[config.motors.b.dir].set(0)

right = ->
  if config.isPI
    pins[config.motors.a.pow].set()
    pins[config.motors.a.dir].set(0)
    pins[config.motors.b.pow].set(0)
    pins[config.motors.b.dir].set()

pins = {}

module.exports = (socket) ->

  if config.isPI
    #TODO: change these pins to your pins in ./config.coffee
    #Motor A
    pins[config.motors.a.pow] = gpio.export config.motors.a.pow, 
      direction: 'out'
      interval: 200
      ready: ->
        console.log "motors.a.pow ready"

    pins[config.motors.a.dir] = gpio.export config.motors.a.dir, 
      direction: 'out'
      interval: 200
      ready: ->
        console.log "motors.a.dir ready"

    #Motor B
    pins[config.motors.b.pow] = gpio.export config.motors.b.pow, 
      direction: 'out'
      interval: 200
      ready: ->
        console.log "motors.b.pow ready"

    pins[config.motors.b.dir] = gpio.export config.motors.b.dir, 
      direction: 'out'
      interval: 200
      ready: ->
        console.log "motors.b.dir ready"
    
    stop()

  # listen for different socket events
  socket?.emit "feedback", "I am your father"

  socket.on "disconnect", ->
    for pin in pins
      pin.unexport()
    console.log "disconnected"

  socket.on "up", (data) ->
    socket?.emit "feedback", "and away"
    forward()
    console.log "up!"

  socket.on "down", (data) ->
    socket?.emit "feedback", "and out"
    backward()
    console.log "down!"

  socket.on "left", (data) ->
    socket?.emit "feedback", "loosey"
    left()
    console.log "left!"

  socket.on "right", (data) ->
    socket?.emit "feedback", "tighty"
    right()
    console.log "right!"

  socket.on "stop", (data) ->
    socket?.emit "feedback", "halt!"
    stop()
    console.log "stop!"

