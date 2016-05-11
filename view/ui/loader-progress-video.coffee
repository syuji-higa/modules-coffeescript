$ = require 'jquery'
Elements = require '../elements'
PreloadImage = require '../request/preload-image'
{ instances } = require '../../requires/instances'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class Loader

  opts =
    selectors:
      wrap    : '.wrap'
      progress: '.progress-bar .bar'

  ###
  create FlatHeight instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @selectors } = _.defaultsDeep opts, defOpts

    @$window   = Elements.$window
      .on 'videoLoaded', @onVideoLoaded
    @$wrap     = $ selectors.wrap
    @$loader   = $ el
    @$progress = @$loader.find selectors.progress

    @images = new PreloadImage selectors.wrap
    @images.load()

    @video = instances.video

    @progressTimer = null
    @imageLen      = @images.images.length
    @videoLen      = 1
    @totalLen      = @imageLen + @videoLen
    @videoLoaded   = 0
    @totalLoaded   = 0

    setTimeout =>
      @checkProgress()
    , 500

  ###
  @private
  ###
  onVideoLoaded: =>
    @videoLoaded = 1

  ###
  @private
  ###
  checkProgress: ->
    clearTimeout @progressTimer
    @progressTimer = setTimeout =>
      @totalLoaded = Math.round (((@images.loaded + @videoLoaded) / @totalLen) * 100)
      @progressAnime()
    , 100

  ###
  @private
  ###
  progressAnime: ->
    @$progress
      .velocity 'stop'
      .velocity
        width: "#{@totalLoaded}%"
      ,
        duration: 500
        complete: =>
          if 100 > @totalLoaded
            @checkProgress()
          else
            @showConetnts()

  ###
  @private
  ###
  showConetnts: ->
    @$loader.velocity
      opacity: 0
    ,
      duration: 2000
      display : 'none'
      complete: =>
        @$wrap.css 'height', 'auto'
        @$window.trigger 'contentsShown'
