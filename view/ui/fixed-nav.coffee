$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'
{ getPrefixCssName } = require '../get/css'
{ setCss } = require '../velocity/operation/element'
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

  ###
  create FlatHeight instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @pointSeletctor } = _.defaults opts, defOpts

    @$window = Elements.$window
      .one 'load', @onWindowLoaded
      .on 'scroll', _.throttle @checkScrollPoint, 200
    @$nav = $ el
      .css getPrefixCssName('backface-visibility'), 'hidden'
    @$point = $ @pointSeletctor

    @isShown = false

  ###
  @private
  ###
  onWindowLoaded: =>
    @point = @$point.offset().top
    @navH  = @$nav.height()

    ###
    create veloctiy toggle animation method
    ###
    @toggleNav = new ToggelAnime
      el: @$nav
      type: [
        translateY: 0
      ,
        translateY: @navH
      ]
      opts:
        duration: 300
        easing  : 'easeOutCubic'

    setCss @$nav, { translateY: -@navH }

    @checkScrollPoint()

  ###
  @private
  ###
  checkScrollPoint: =>
    if @point <= @$window.scrollTop()
      return if @isShown
      @toggleNav.run true
      @isShown = true
    else
      return unless @isShown
      @toggleNav.run false
      @isShown = false
