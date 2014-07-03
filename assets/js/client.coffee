#= require jquery
#= require socket.io

$( ->
  # set up the socket.io
  socket = io.connect() 

  socket.on "connect", (msg) ->

  socket.on "feedback", (msg) ->
    $("#feedback").text msg

  socket.on "still", (msg) ->
    img = new Image()
    img.src = "data:image/jpeg;base64,#{msg}"
    img.onload = ->
      if @.complete
        $("#still").attr 'src', @.src
    socket.emit "getImage"

  setTimeout ->
    socket.emit "getImage"
  , 100

  $('.emitter').on 'mousedown, touchstart', (e)->
    $el = $(e.currentTarget)
    socket.emit $el.data('channel'), $el.data 'value'

  $('.emitter').on 'mouseup, touchend', (e)->
    setTimeout ->
      socket.emit "stop", "stop"
    , 10

  $(window).keydown (e)->
    for el in $("[data-keyboard]")
      $el = $(el)
      if e.which == $el.data 'keyboard'
        socket.emit $el.data('channel'), $el.data 'value'

  $(window).keyup (e)->
    setTimeout ->
      socket.emit "stop", "stop"
    , 10

)
