$ = require 'jquery'
_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class Scroll

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    triggerSelector: null
    duration       : 600
    easing         : 'easeOutQuad'
    offset         : 0

  ###
  create Scroll instance
  @param el [String|HTMLElement] target element
  @param opts [Object] options
  ###
  constructor: (@el, opts = {}) ->
    @opts = _.defaults opts, defOpts

  ###
  @param el [String|HTMLElement] target element
  @param opts [Object] options
  ###
  run: (el = @el, opts = {}) ->
    { triggerSelector, duration, easing, offset } = _.defaults opts, @opts

    $trigger = $ triggerSelector

    $ el
      .velocity 'stop'
      .velocity 'scroll',
        duration: duration
        easing  : easing
        offset  : offset
        begin   : =>
          if $trigger.size()
            $trigger.triggerHandler 'beforeScroll'
        complete: =>
          if $trigger.size()
            $trigger.triggerHandler 'afterScroll'
