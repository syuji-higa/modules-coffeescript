$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'
{ getPrefixCssName } = require '../get/css'
{ setCss } = require '../velocity/operation/element'
ToggelClass = require '../operation/toggle-class'
ToggelAnime = require '../velocity/operation/toggle-anime'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class FixedNav

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    pointSeletctor: '.js-fixed-nav-point'
    fixedClass    : 'is-fixed'
    navHeight     : 50
    breakPoint    : 768

  ###
  create FlatHeight instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @pointSeletctor, @fixedClass, @navHeight, @breakPoint } = _.defaults opts, defOpts

    @$window = Elements.$window
      .one 'load', @onWindowLoaded
      .on 'resize', @onWindowResized
    @$nav = $ el
      .css getPrefixCssName('backface-visibility'), 'hidden'
    @$point = $ @pointSeletctor

    @isIE8 = !$.support.opacity

    @isShown      = false
    @isWideDevice = false
    @isSet        = false

  ###
  @private
  ###
  onWindowLoaded: =>
    @checkBreakPoint()

  ###
  @private
  ###
  onWindowResized: =>
    @checkBreakPoint()

  ###
  @private
  ###
  checkBreakPoint: ->
    @winInrW =
      if !@isIE8 then @$window.get(0).innerWidth else document.body.clientWidth

    if @breakPoint < @winInrW
      return if @isWideDevice
      @isWideDevice = true
      @$window.on 'scroll', @throttleCheckScrollPoint
      @set() unless @isSet
    else
      return unless @isWideDevice
      @isWideDevice = false
      @$window.off 'scroll', @throttleCheckScrollPoint

    @checkScrollPoint() if @isWideDevice

  ###
  @private
  ###
  set: ->
    @point = @$point.offset().top

    ###
    create toggle class method
    ###
    @toggleClass = new ToggelClass @fixedClass, @$nav

    ###
    create veloctiy toggle animation method
    ###
    @toggleNavFV = new ToggelAnime
      el: @$nav
      type: [
        translateY: [ 0, -@navHeight ]
      ,
        translateY: [ -@navHeight, 0 ]
      ]
      opts:
        duration: 300
        easing  : 'easeOutCubic'

    @toggleNav = new ToggelAnime
      el: @$nav
      type: [
        opacity   : [ 1, 0 ]
        translateY: [ 0, 'easeOutCubic' ]
      ,
        opacity: [ 0, 1 ]
      ]
      opts:
        duration: 300

    @isSet = true

  ###
  @private
  ###
  throttleCheckScrollPoint: =>
    _.throttle(@checkScrollPoint, 200)()

  ###
  @private
  ###
  checkScrollPoint: =>
    if @point <= @$window.scrollTop()
      return if @isShown
      @toggleNav.run false,
        opts:
          complete: =>
            @$nav.css 'opacity', 1
            @toggleClass.run true
            setTimeout =>
              @toggleNavFV.run true
            , 0
      @isShown = true
    else
      return unless @isShown
      @toggleNavFV.run false,
        opts:
          complete: =>
            @toggleClass.run false
            setTimeout =>
              @toggleNav.run true
            , 0
      @isShown = false
