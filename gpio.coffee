
gpio    = require 'rpi-gpio'
config  = require './config'

forward = ->
  if config.isPI
    # set motor a to forward
    gpio.write config.motors.a.dir, false, (err) ->
      console.log(err) if err?
    gpio.write config.motors.a.pow, true, (err) ->
      console.log(err) if err?

    # set motor b to forward
    gpio.write config.motors.b.dir, false, (err) ->
      console.log(err) if err?
    gpio.write config.motors.b.pow, true, (err) ->
      console.log(err) if err?

  console.log 'drove forward'


backward = ->
  if config.isPI
    # set motor a to backward
    gpio.write config.motors.a.dir, true, (err) ->
      console.log(err) if err?
    gpio.write config.motors.a.pow, true, (err) ->
      console.log(err) if err?

    # set motor b to backward
    gpio.write config.motors.b.dir, true, (err) ->
      console.log(err) if err?
    gpio.write config.motors.b.pow, true, (err) ->
      console.log(err) if err?

  console.log 'drove backward'

left = ->
  if config.isPI
    # set motor a to left
    gpio.write config.motors.a.dir, true, (err) ->
      console.log(err) if err?
    gpio.write config.motors.a.pow, true, (err) ->
      console.log(err) if err?

    # set motor b to left
    gpio.write config.motors.b.dir, false, (err) ->
      console.log(err) if err?
    gpio.write config.motors.b.pow, true, (err) ->
      console.log(err) if err?

  console.log 'drove left'

right = ->
  if config.isPI
    # set motor a to right
    gpio.write config.motors.a.dir, false, (err) ->
      console.log(err) if err?
    gpio.write config.motors.a.pow, true, (err) ->
      console.log(err) if err?

    # set motor b to right
    gpio.write config.motors.b.dir, true, (err) ->
      console.log(err) if err?
    gpio.write config.motors.b.pow, true, (err) ->
      console.log(err) if err?

  console.log 'drove right'

module.exports = (socket) ->

  if config.isPI
    #TODO: change these pins to your pins in ./config.coffee
    #Motor A
    gpio.setup config.motors.a.dir, gpio.DIR_OUT, (err) ->
      console.log(err) if err?
    gpio.setup config.motors.a.pow, gpio.DIR_OUT 

    #Motor B
    gpio.setup config.motors.b.dir, gpio.DIR_OUT 
    gpio.setup config.motors.b.pow, gpio.DIR_OUT 

  # listen for different socket events
  socket?.emit "feedback", "I am your father"

  socket.on "disconnect", ->
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
    console.log "left!"

