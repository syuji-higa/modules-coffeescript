$ = require 'jquery'

###
@dependsOn jquery
###
module.exports =
class TapEvent

  ###
  create TapEvent instance
  @param el [String|HTMLElement] element
  ###
  constructor: (el) ->
    $ el
      .on
        'touchstart mousedown': @onTouchstart
        'touchmove mousemove' : @onTouchmove
        'touchend mouseup'    : @onTouchend

    @isTouchstart = false

  ###
  @private
  @param e [Evnet] touch stat event
  ###
  onTouchstart: (e) =>
    @isTouch = true
    @isTap   = true
    if @hasTouchEvent
      @touchX = event.changedTouches[0].pageX
      @touchY = event.changedTouches[0].pageY
    else
      @touchX = event.pageX
      @touchY = event.pageY
    @slideX  = 0
    @slideY  = 0
    setTimeout =>
      @isTap = false
    , 500

  ###
  @private
  @param e [Evnet] touch move event
  ###
  onTouchmove: (e) =>
    if @hasTouchEvent
      @slideX = @touchX - event.changedTouches[0].pageX
      @slideY = @touchY - event.changedTouches[0].pageY
    else
      @slideX = @touchX - event.pageX
      @slideY = @touchY - event.pageY

  ###
  @private
  @param e [Evnet] touch end event
  ###
  onTouchend: (e) =>
    if @hasTouchEvent
      x = event.changedTouches[0].pageX
      y = event.changedTouches[0].pageY
    else
      x = event.pageX
      y = event.pageY


    if 10 > (@slideX || 0) > -10 and
       10 > (@slideY || 0) > -10
      return unless @isTap
      if !@isDbTap
        $ e.currentTarget
          .trigger 'tap', e
      else
        if (@endX + 20) > x > (@endX - 20) and
           (@endY + 20) > y > (@endY - 20)
          $ e.currentTarget
            .trigger 'doubleTap', e
    else
      $ e.currentTarget
        .trigger 'swipe', e

    @endX = x
    @endY = y

    @isTouch = false
    @isDbTap = true
    setTimeout =>
      @isDbTap = false
    , 500
