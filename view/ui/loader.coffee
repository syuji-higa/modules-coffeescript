$ = require 'jquery'
Elements = require '../elements'
PreloadImage = require '../request/preload-image'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class Loader

  defOpts =
    selectors:
      wrap: '.wrap'

  ###
  create Loader instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @selectors } = _.defaultsDeep opts, defOpts

    @$window = Elements.$window
    @$wrap   = $ @electors.wrap
    @$loader = $ el

    @images = new PreloadImage @electors.wrap
    @images.load()
      .then =>
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
