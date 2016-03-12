$ = require 'jquery'
_ = require 'lodash'

tag            = document.createElement 'script'
tag.src        = "https://www.youtube.com/iframe_api"
firstScriptTag = document.getElementsByTagName('script')[0]
firstScriptTag.parentNode.insertBefore tag, firstScriptTag

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class Youtube

  @players: {}

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    width : 560
    height: 315
    playerVars:
      autoplay      : 0
      controls      : 1
      modestbranding: 1
      rel           : 0
      showInfo      : 0

  ###
  create Youtube instance
  @param elName [String] element id name
  @param videoId [String] youtube video id
  @param opts [Object] options

  @example create instance
    new Youtube 'id','xxxxxxxxxxx'
  ###
  constructor: (@elName, @videoId, opts = {}) ->
    @opts = _.defaultsDeep opts, defOpts
    @opts.videoId = @videoId
    @opts.events =
      'onReady'                : @onReady
      'onStateChange'          : @onStateChange
      'onPlaybackQualityChange': @onPlaybackQualityChange
      'onPlaybackRateChange'   : @onPlaybackRateChange
      'onError'                : @onError
      'onApiChange'            : @onApiChange

    @$el = $ "##{@elName}"

    if typeof(YT) is 'undefined' or typeof(YT.Player) is 'undefined'
      window.onYouTubeIframeAPIReady = =>
        @load()
      $.getScript '//www.youtube.com/iframe_api'
    else
      @load()

  ###
  @private
  load youtube player
  ###
  load: ->
    Youtube.players[@videoId] = @player = new YT.Player @elName, @opts

  ###
  @private
  ###
  onReady: (e) =>
    @$el.triggerHandler 'onPlayerReady', [e]

  ###
  @private
  ###
  onStateChange: (e) =>
    @$el.triggerHandler 'onStateChange', [e]

  ###
  @private
  ###
  onPlaybackQualityChange: (e) =>
    @$el.triggerHandler 'onPlaybackQualityChange', [e]

  ###
  @private
  ###
  onPlaybackRateChange: (e) =>
    @$el.triggerHandler 'onPlaybackRateChange', [e]

  ###
  @private
  ###
  onError: (e) =>
    @$el.triggerHandler 'onError', [e]

  ###
  @private
  ###
  onApiChange: (e) =>
    @$el.triggerHandler 'onApiChange', [e]
