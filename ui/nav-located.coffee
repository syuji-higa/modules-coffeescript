$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn throttle
###
module.exports =
class NavLocated

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    wrapSelector: '.wrapper'
    linkSelector: 'li a'
    locatedClass: 'is-located'

  ###
  create NavLocated instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @wrapSelector, @linkSelector, @locatedClass } = _.defaults opts, defOpts

    @$window = Elements.$window
      .one 'load', @onWindowLoaded
      .on
        'scroll': @onWindowScrolled
        'resize': @onWindowResized
    @$wrap   = $ @wrapSelector
    @$nav    = $ el
    @$link   = @$nav.find @linkSelector
    @$points = _.map @$link, (link) ->
      $ $(link).attr('href')

    @points   = []
    @location = null
    @navH     = @$nav.height()
    @linkLen  = @$link.length

    @throttle =
      setPoints : _.throttle 500, @setPoints
      setLocated: _.throttle 200, @setLocated

  ###
  @private
  ###
  onWindowLoaded: =>
    @winY  = @$window.scrollTop()
    @wrapH = @$wrap.height()
    @navH  = @$nav.height()

    @setPoints()
    @setLocated()

  ###
  @private
  ###
  onWindowScrolled: =>
    @winY = @$window.scrollTop()
    @throttle.setLocated()

  ###
  @private
  ###
  onWindowResized: =>
    @throttle.setPoints()
    @throttle.setLocated()

  ###
  @private
  ###
  setPoints: =>
    pointsOrg = _.map @$points, ($point) ->
      $point.offset().top
    points = [0]
    _.forEach pointsOrg, (point, i) =>
      points.push point - @navH
    points.push @wrapH
    @points = points

  ###
  @private
  ###
  setLocated: =>
    _.forEach @points, (point, i) =>
      if point <= @winY and @points[i + 1] > @winY
        return if @location is i

        oldIndex = @location - 1
        if 0 <= oldIndex
          @$link.eq oldIndex
            .removeClass @locatedClass
        if i
          @$link.eq i - 1
            .addClass @locatedClass

        @location = i
