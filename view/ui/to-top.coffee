$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'
{ displayMoment } = require '../operation/element'
{ getPrefixCssName } = require '../get/css'
{ setCss } = require '../velocity/operation/element'
ToggleAnime = require '../velocity/operation/toggle-anime'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class ToTop

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    showPointSeletctor: '.js-to-top-show-point'
    stopPointSeletctor: '.js-to-top-stop-point'
    animeOpts:
      duration: 300
      easing  : 'easeOutCubic'

  ###
  create FlatHeight instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @showPointSeletctor, @stopPointSeletctor, @animeOpts } = _.defaults opts, defOpts

    @$window    = Elements.$window
      .one 'load', @onWindowLoaded
    @$toTop     = $ el
    @$showPoint = $ @showPointSeletctor
    @$stopPoint = $ @stopPointSeletctor

    @isStopPoint =
      if @$stopPoint.length then true else false

    @isShown = false
    @isStop = false if @isStopPoint

    # # case of Transform
    # @$toTop
    #   .css getPrefixCssName('backface-visibility'), 'hidden'

  ###
  @private
  ###
  onWindowLoaded: =>
    @reset()

    # # case of translate
    # displayMoment @$toTop, =>
    #   @shiftY = @winH - (@$toTop.offset().top - @$window.scrollTop())

    ###
    create veloctiy toggle animation method
    ###
    @toggleAnime = new ToggleAnime
      el  : @$toTop
      type: [
        opacity: 1
        # translateY: 0
      ,
        opacity: 0
        # translateY: @shiftY
      ]
      opts: @animeOpts

    ###
    create throttole method
    ###
    @throttleCheckShowPoint = _.throttle @checkShowPoint, 200

    @$window.on
      'scroll': @checkScrollPoint
      'resize': _.throttle @onWindowResized, 200

    # # case of translate
    # setCss @$toTop, { translateY: @shiftY }
    @$toTop.css 'opacity', 0

    @checkScrollPoint()

  ###
  @private
  ###
  onWindowResized: =>
    @reset()
    @checkScrollPoint()

  ###
  @private
  ###
  reset: =>
    @winH      = @$window.height()
    @showPoint = @$showPoint.offset().top
    @stopPoint = @getStopPoint() if @isStopPoint

  ###
  @private
  ###
  checkScrollPoint: =>
    @winScrollY = @$window.scrollTop()

    @throttleCheckShowPoint()
    @checkStopPoint() if @isStopPoint

  ###
  @private
  ###
  checkShowPoint: ->
    if @showPoint <= @winScrollY
      return if @isShown
      @toggleAnime.run true
      @isShown = true
    else
      return unless @isShown
      @toggleAnime.run false
      @isShown = false

  ###
  @private
  ###
  checkStopPoint: ->
    if @stopPoint >= @winScrollY
      if @isStop
        @setPointToTop()
        @isStop = false
    else
      @setPointToTop()
      @isStop = true unless @isStop

  ###
  @private
  ###
  setPointToTop: ->
    y = @winScrollY - @stopPoint
    y = if 0 <= y then y else 0
    setCss @$toTop, { translateY: -y }

  ###
  @private
  @return [Integer] toTop element stop point
  ###
  getStopPoint: ->
    @$stopPoint.offset().top - @winH
