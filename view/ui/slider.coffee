$ = require 'jquery'
require 'slick'

module.exports =
class Slider

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    slickOpts:
      dots         : true
      arrows       : true
      infinite     : true
      speed        : 500
      # autoplay     : true
      # autoplaySpeed: 5000
      # centerMode   : true
      # slidesToShow : 1
      # centerPadding: 0
      # centerMode   : true

  ###
  create Slider instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { slickOpts } = _.defaultsDeep opts, defOpts

    $ el
      .slick slickOpts
