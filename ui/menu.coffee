$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'
Hammer = require 'hammer'
Anchor = require '../components/anchor'
ToggleAnime = require '../velocity/operation/toggle-anime'
{ getPrefixCssName } = require '../get/css'
require '../../vendors/jquery.flicksimple.custom'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn hammer
@dependsOn jquery.flicksimple.custom
@dependsOn velocity
###
module.exports =
class Menu

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    selectors:
      header: 'header'
      inr1  : '.js-menu-inner-1'
      inr2  : '.js-menu-inner-2'
      btn   : '.js-menu-btn'
      close : '.js-menu-close'
    isCloseClass  : 'is-opened'
    bgClass       : 'js-menu-bg'

  ###
  create Menu instance
  @param el [String|HTMLElement] element
  ###
  constructor: (el, opts = {}) ->
    { @selectors, @isCloseClass, @bgClass } = _.defaultsDeep opts, defOpts

    @$window = Elements.$window
      .one 'load', @onWindowLoaded
      .on 'resize', @onWindowResized
    @$body   = $ 'body'
    @$header = $ @selectors.header
      .on 'touchstart', @onHeaderTouchstart
    @$menu   = $ el
    @$inr1   = @$menu.find @selectors.inr1
    @$inr2   = @$menu.find @selectors.inr2
    @$btn    = $ @selectors.btn
    @$close  = @$menu.find @selectors.close
    @$link   = @$menu.find 'a'

    @isOpen  = false
    @isAnima = false

    @$body.prepend "<div class='#{@bgClass}'></div>"
    @$bg = $ ".#{@bgClass}"
      .on 'touchstart', (e) => e.preventDefault()

    new Hammer @$btn.get(0)
      .on 'tap', @onBtnTaped
    new Hammer @$close.get(0)
      .on 'tap', @close
    new Hammer @$bg.get(0)
      .on 'tap', @close
    _.forEach @$link, (el) =>
      new Hammer el
        .on 'tap'  , => @onLinkTaped el
        .on 'swipe', => @onLinkSwiped el

    _.forEach @$link, (link) =>
      $el  = $ link
      href = $el.attr('href')
      hash = href.match(/(#.+)$/)?[0]
      data =
        if hash then hash else href
      $el.attr 'data-href', data

    @$inr1.flickSimple
      vertical  : true
      horizontal: false
      lock      : true
      snap      : 0

    ###
    create veloctiy toggle animation method
    ###
    @toggleMenu = new ToggleAnime
      el  : @$menu
      type: [
        translateY: [ 0, '-100%' ]
      ,
        translateY: [ '-100%', 0 ]
      ]
      opts:
        duration: 500
        easing  : 'easeOutCubic'

  ###
  @private
  ###
  onWindowLoaded: =>
    @headerH    = @$header.height()
    @shiftY  = @getShiftY()

  ###
  @private
  ###
  onWindowResized: =>
    @$inr2.css getPrefixCssName('transform'), 'translate3d(0, 0, 0)'
    @setHeight()

  ###
  @private
  @param e [Event] event
  ###
  onHeaderTouchstart: (e) =>
    if @isOpen then e.preventDefault()

  ###
  @private
  ###
  onBtnTaped: =>
    if @isAnima then return else @isAnima = true
    if @$menu.is ':hidden'
      @open()
    else
      @close()

  ###
  @private
  @param e [Event] event
  ###
  onLinkTaped: (el) =>
    @close =>
      $el  = $ el
      href = $el.data 'href'
      if href.match /^#.+/
        Anchor.prototype.scroll href, $el, { offset: -@headerH }
      else
        location.href = href

  ###
  @private
  @param e [Event] event
  ###
  onLinkSwiped: (e) =>
    $.flickSimple.prototype.touchend e, true

  ###
  @private
  ###
  open: =>
    @shiftY = @getShiftY()
    @$menu.css 'top', @shiftY
    @toggleBg 'fadeIn'
    @toggleMenu.run true,
      opts:
        complete: =>
          @setHeight()
          @$inr1
            .flickSimple()
            .updateSize()
          @toggleClass()
          @isOpen  = true
          @isAnima = false

  ###
  @private
  @param cb [Function] callback
  ###
  close: (cb = null) =>
    @toggleBg 'fadeOut'
    @toggleMenu.run false,
      opts:
        complete: =>
          @toggleClass()
          @$inr1.height 'auto'
          @isOpen  = false
          @isAnima = false
          cb?()

  ###
  @private
  ###
  flickMenu: ->
    winH = window.innerHeight
    @$inr2.css 'min-height', 'auto'
    if winH - @shiftY > @$inr2.height()
      @$inr2.css 'min-height', '100%'
      h = '100%'
    else
      h = winH - @shiftY
    @$inr1.height h

  ###
  @private
  ###
  toggleClass: ->
    @$btn.toggleClass @isCloseClass

  ###
  @private
  @param type [String] animation type name
  ###
  toggleBg: (type) ->
    @$bg
      .css
        height: @$body.height()
      .velocity type,
        duration: 500

  ###
  @private
  @return [Number] shift y
  ###
  getShiftY: ->
    y = @headerH - @$window.scrollTop()
    if 0 <= y then y else 0
