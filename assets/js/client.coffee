#= require jquery
#= require bootstrap
#= require socket.io

$( ->
  # set up the socket.io
  socket = io.connect() 

  socket.on "connect", (msg) ->
    socket.emit "hello", "world"

  socket.on "feedback", (msg) ->
    $("#feedback").text msg

  socket.on "still", (msg) ->
    $("#still").attr 'src', "data:image/jpeg;base64,#{msg}"

  $('.emitter').on 'mousedown, touchstart', (e)->
    $el = $(e.currentTarget)
    socket.emit $el.data('channel'), $el.data 'value'

  $('.emitter').on 'mouseup, touchend', (e)->
    socket.emit "stop", "stop"

  $(window).keydown (e)->
    for el in $("[data-keyboard]")
      $el = $(el)
      if e.which == $el.data 'keyboard'
        socket.emit $el.data('channel'), $el.data 'value'

  $(window).keyup (e)->
    socket.emit "stop", "stop"

)
