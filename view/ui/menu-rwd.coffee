$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'
Hammer = require 'hammer'
Anchor = require './anchor'
ToggleAnime = require '../velocity/operation/toggle-anime'
{ getPrefixCssName } = require '../get/css'
{ setCss } = require '../velocity/operation/element'
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
      inr1  : '.js-menu-inner-1'
      inr2  : '.js-menu-inner-2'
      btn   : '.js-menu-open'
      close : '.js-menu-close'
    isOpendClass: 'is-opened'
    bgClass     : 'js-menu-bg'
    breakPoint  : 768

  ###
  create Menu instance
  @param el [String|HTMLElement] element
  ###
  constructor: (el, opts = {}) ->
    { @selectors, @isOpendClass, @bgClass, @breakPoint } = _.defaultsDeep opts, defOpts

    @$window = Elements.$window
      .one 'load', @onWindowLoaded
      .on 'resize', @onWindowResized
    @$body   = $ 'body'
    @$menu   = $ el
    @$inr1   = @$menu.find @selectors.inr1
    @$inr2   = @$menu.find @selectors.inr2
    @$btn    = $ @selectors.btn
    @$close  = @$menu.find @selectors.close
    @$link   = @$menu.find 'a'

    @isNarrowDevice      = false
    @isNarrowDeviceFirst = true
    @isOpen              = false
    @isAnima             = false

    @$body.prepend "<div class='#{@bgClass}'></div>"
    @$bg = $ ".#{@bgClass}"

    @$link.on 'click', (e) =>
      e.preventDefault()

    @hammerBtn   = new Hammer @$btn.get(0)
    @hammerClose = new Hammer @$close.get(0)
    @hammerBg    = new Hammer @$bg.get(0)
    @hammersLink = _.map @$link, (el) =>
      new Hammer el

    @$menu.css 'display', 'block'

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
    @winInrW = window.innerWidth

    @checkBreakPoint true

  ###
  @private
  ###
  onWindowResized: =>
    @winInrW = window.innerWidth

    @checkBreakPoint()

    if @isNarrowDevice
      @$inr2.css getPrefixCssName('transform'), 'translate3d(0, 0, 0)'
      @flickMenu()

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
  @param el [String|HTMLElement] element
  ###
  onLinkTaped: (el) =>
    $el  = $ el
    href = $el.data 'href'
    @close =>
      if href.match /^#.+/
        Anchor.prototype.scroll href, $el
      else
        location.href = href

  ###
  @private
  @param e [Event] event
  ###
  onLinkSwiped: (e) =>
    $.flickSimple.prototype.touchend e.srcEvent, true

  ###
  @private
  ###
  checkBreakPoint: ->
    if @breakPoint >= @winInrW

      return if @isNarrowDevice
      @$bg.on 'touchstart', (e) => e.preventDefault()
      @hammerBtn.on 'tap', @onBtnTaped
      @hammerClose.on 'tap', @close
      @hammerBg.on 'tap', @close
      _.forEach @hammersLink, (hammer) =>
        hammer
          .on 'tap', (e) =>
            e.preventDefault()
            @onLinkTaped hammer.element
          .on 'swipe', =>
            @onLinkSwiped hammer.element
      @$menu.css 'display', 'none'
      @toggleLink false

      if @isNarrowDeviceFirst
        @$inr1.flickSimple
          vertical  : true
          horizontal: false
          lock      : true
          snap      : true
        @$link.attr 'href', ''
        @positonTop = Number @$menu.css('top').replace('px', '')
        @isNarrowDeviceFirst = false
      else
        @$inr1.flickSimple 'on'

      @isNarrowDevice = true

    else

      return unless @isNarrowDevice
      @$bg.off 'touchstart'
      @hammerBtn.off 'tap', @onBtnTaped
      @hammerClose.off 'tap', @close
      @hammerBg.off 'tap', @close
      _.forEach @hammersLink, (hammer) =>
        hammer.off 'tap swipe'
      @$inr1.flickSimple 'off'
      @$menu.css 'display', 'block'
      setCss @$menu, { translateY: 0 }
      @$bg.css 'display', 'none'
      @toggleLink true
      @isNarrowDevice = false

  ###
  @private
  @param toggle [Boolean] toggle link
  ###
  toggleLink: (toggle) ->
    if toggle
      _.forEach @$link, (link) =>
        $el  = $ link
        href = $el.data 'href'
        return unless href
        $el
          .attr 'href', href
          .attr 'data-href', ''
    else
      _.forEach @$link, (link) =>
        $el  = $ link
        href = $el.attr 'href'
        hash = href.match(/(#.+)$/)?[0]
        data =
          if hash then hash else href
        $el
          .attr 'data-href', data
          .attr 'href', ''

  ###
  @private
  ###
  open: =>
    @toggleBg 'fadeIn'
    @toggleMenu.run true,
      opts:
        complete: =>
          @flickMenu()
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
          @isOpen  = false
          @isAnima = false
          cb?()

  ###
  @private
  ###
  flickMenu: ->
    winH = window.innerHeight
    @$inr2.css 'min-height', 'auto'
    if winH - @positonTop > @$inr2.height()
      @$inr2.css 'min-height', '100%'
      h = '100%'
    else
      h = winH - @positonTop
    @$inr1.height h

  ###
  @private
  ###
  toggleClass: ->
    @$btn.toggleClass @isOpendClass

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
