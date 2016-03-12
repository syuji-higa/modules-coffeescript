$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class FixedScrollX

  ###
  create FixedScrollX instance
  @param $el [jQueryObject] element
  @param contentsMinW [Integer] contents mini width
  @param resetX [Integer] reset x position
  ###
  constructor: (@$el, @contentsMinW, @resetX = 0) ->
    @$window = Elements.$window
      .one 'load', @onWindowLoaded
      .on
        'scroll': @onWindowScrolled
        'resize': @onWindowResize
    @winX = @$window.scrollLeft()
    @winW = @$window.width()

    @throttle =
      winX       : _.throttle 200, => @winX = @$window.scrollLeft()
      scorllXWinX: _.throttle 200, @scorllX
      winW       : _.throttle 500, => @winW = @$window.width()
      resetNavX  : _.throttle 500, @resetNavX

  ###
  @private
  ###
  onWindowLoaded: =>
    @scorllX()

  ###
  @private
  ###
  onWindowScrolled: =>
    @throttle.winX()
    @throttle.scorllXWinX()

  ###
  @private
  ###
  onWindowResize: =>
    @throttle.winW()
    @throttle.resetNavX()

  ###
  @private
  ###
  scorllX: =>
    return if @contentsMinW < @winW
    if @$el.css('position') is 'fixed'
      @setNavX -@winX
    else
      @setNavX @resetX

  ###
  @private
  ###
  resetNavX: =>
    return if @contentsMinW >= @winW
    @setNavX @resetX

  ###
  @private
  @param x [Object] new x position
  ###
  setNavX: (x) ->
    _x = parseInt @$el.css('left')
    return if _x is x
    @$el.css
      left: x
