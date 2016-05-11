$ = require 'jquery'
# _ = require 'lodash'
Elements = require '../elements'
require 'remodal'

###
@dependsOn jquery
###
module.exports =
class Remodal

  selector: '.remodal'

  ###
  create Remodal instance
  ###
  constructor: ->
    Elements.$document
      .on 'opening', @selector, @onRemodalOpening
      .on 'closed', @selector, @onRemodalClosed
    Elements.$window
      .on 'resize', @onWindowResized
    @$body = Elements.$body

    @bodyW    = @$body.width()
    @shiftX   = null
    @isOpened = false

  ###
  @private
  ###
  onWindowResized: =>
    if !@isOpened
      @bodyW = @$body.width()
    else
      @$body
        .width 'auto'
        .width @$body.width() - @shiftX

  ###
  @private
  ###
  onRemodalOpening: =>
    if @shiftX is null
      @shiftX = @$body.width() - @bodyW
    console.log @shiftX
    @$body.width @bodyW
    @isOpened = true

  ###
  @private
  ###
  onRemodalClosed: =>
    @$body.width 'auto'
    @bodyW = @$body.width()
    @isOpened = false
