$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class Fit

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    minWidth : 0
    minHeight: 0
    shiftX   : 0
    shiftY   : 0

  ###
  create Fit instance
  @param el [String|HTMLElement] element
  @param ratio [Number] ratio
  @param opts [Object] options
  ###
  constructor: (el, @ratio, opts = {}) ->
    { @minWidth, @minHeight, @shiftX, @shiftY } = _.defaults opts, defOpts

    @$window = Elements.$window
      .one 'load' , => @sizing @getPrams()
      .on 'resize', => @sizing @getPrams()
    @$el = $ el

  ###
  @private
  @param params [Object] size and postion
  ###
  sizing: (params) ->
    @$el.css params

  ###
  @private
  @return [Object] size and postion
  ###
  getPrams: ->
    w      = @getWidth()
    h      = @getHeight()
    shiftX = Math.max 0, @shiftX
    shiftY = Math.max 0, @shiftY

    if @ratio < @getRatio()
      {
        width : w
        height: w / @ratio
        top   : -(Math.abs(((w / @ratio) - h) / 2)) + shiftY
        left  :  shiftX
      }
    else
      {
        width : h * @ratio
        height: h
        top   : shiftY
        left  : -(((h * @ratio) - w) / 2) + shiftX
      }

  ###
  @private
  @return [Number] width
  ###
  getWidth: ->
    Math.max(@minWidth, @$window.width()) - Math.abs(@shiftX)

  ###
  @private
  @return [Number] height
  ###
  getHeight: ->
    Math.max(@minHeight, @$window.height()) - Math.abs(@shiftY)

  ###
  @private
  @return [Number] ratio
  ###
  getRatio: ->
    @getWidth() / @getHeight()
