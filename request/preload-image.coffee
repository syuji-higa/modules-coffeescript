$ = require 'jquery'
_ = require 'lodash'
Browser = require '../models/browser'
{ getBgImg } = require '../get/css'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn css-operation
###
module.exports =
class PreloadImage

  ###
  @static
  loaded images data
  ###
  @data: []

  ###
  create PreloadImage instance
  @param $el [jQueryObject] element
  @param images [Array] images
  ###
  constructor: (@el, @images = []) ->
    $el = $ @el
    @loaded = 0

    browser = new Browser
    @isIE9Below =
      if browser?.msie and (10 > browser?.versionNumber)
        true
      else
        false

    images = _.map $el.find('img'), (img) ->
      img.src

    bgImages = _.compact _.map $el.find('*'), (el) ->
      getBgImg $(el)
    bgImg = getBgImg $el
    bgImages.push(bgImg) if bgImg

    data = _.pluck PreloadImage.data, 'src'
    @images = _.union @images, images, bgImages
    @images = _.difference @images, data

  ###
  load images
  ###
  load: ->
    deferreds = _.map @images, (src, i) =>
      dfd = $.Deferred()
      img = new Image

      loadend = =>
        @loaded++
        dfd.resolve()

      success = ->
        PreloadImage.data.push
          src   : img.src
          width : img.width
          height: img.height

      if !@isIE9Below
        img.onload = =>
          success()
          loadend()
        img.onerror = =>
          loadend()
      else
        timer = ->
          setTimeout =>
            if img.width
              success()
              loadend()
            else
              timer()
          , 100
        timer()

      img.src = src
      dfd.promise()

    $.when deferreds...
