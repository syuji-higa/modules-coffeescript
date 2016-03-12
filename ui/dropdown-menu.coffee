$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'
ToggleAnime = require '../../velocity/operation/toggle-anime'
{ getPrefixCssName } = require '../../get/css'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class DropdownMenu

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    selectors:
      btn : '.js-dropdown-menu-btn a'
      cnt : '.js-dropdown-menu-cnt'
      item: '.js-dropdown-menu-item'

  ###
  create DropdownMenu instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { selectors } = _.defaultsDeep opts, defOpts

    Elements.$window
      .on 'load', @onWindowLoaded
    @$menu = $ el
      .on 'mouseleave', @close
    @$btn  = @$menu.find selectors.btn
      .on 'mouseover', @onMouseover
    @$cnt  = @$menu.find selectors.cnt
    @$item = @$menu.find selectors.item

    @selected = null
    @cntH     = 0

    ###
    create veloctiy toggle animation method
    ###
    @toggleCnt = new ToggleAnime
      el  : @$cnt
      opts:
        duration: 300
        easing  : 'easeOutCubic'

    @toggleItem = new ToggleAnime
      type: [
        opacity: [ 1, 0 ]
      ,
        opacity: 0
      ]
      opts:
        duration: 300

    @$cnt.css getPrefixCssName('backface-visibility'), 'hidden'

  ###
  @private
  ###
  onMouseover: (e) =>
    $btn  = $ e.currentTarget
    index = @$btn.index $btn

    return if @selected is index

    $item = @$item.eq index

    $item.css 'z-index', 2

    if @selected is null
      @open $item
    else
      @switch $item, index

    @selected = index

  ###
  @private
  ###
  open: ($item) ->
    @$cnt.css 'display', 'block'
    $item.css
      display: 'block'
      opacity: 1
    @cntH = @$cnt.outerHeight()

    @toggleCnt.run true,
      type:
        translateY: [ 0, -@cntH ]

  ###
  @private
  ###
  switch: ($item, index) ->
    $itemOther = @$item.not ":eq(#{index})"
      .css 'z-index', 1

    @$cnt.height @$cnt.height()

    @$item.css 'position', 'absolute'

    @toggleItem.run false,
      el: $itemOther
    @toggleItem.run true,
      el: $item
      opts:
        complete: =>
          @$item.css 'position', 'static'
          @$cnt.height 'auto'

  ###
  @private
  ###
  close: =>
    return if @selected is null

    @toggleCnt.run false,
      type:
        translateY: -@cntH
      opts:
        complete: =>
          @$item.eq @selected
            .css
              display: 'none'
              zIndex : 1
          @$item.css 'position', 'static'
          @$cnt.height 'auto'
          @selected = null
