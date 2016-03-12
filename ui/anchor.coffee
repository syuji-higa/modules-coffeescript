$ = require 'jquery'
_ = require 'lodash'

###
@dependsOn jquery
@dependsOn velocity
@dependsOn lodash
###
module.exports =
class Anchor

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    duration: 600
    easing  : 'easeOutQuad'
    offset  : 0

  ###
  create Anchor instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @duration, @easing, @offset } = _.defaults opts, defOpts

    @$trigger = $ el
      .on 'click', @onClicked

  ###
  @param el [String|HTMLElement] target element
  @param $trigger [jQueryObject] trigger element
  @param opts [Object] options
  ###
  scroll: (el, $trigger, opts = {}) ->
    unless @duration or @easing or @offset
      { @duration, @easing, @offset } = _.defaults opts, defOpts
    $ el
      .velocity 'stop'
      .velocity 'scroll',
        duration: @duration
        easing  : @easing
        offset  : @offset
        begin   : =>
          $trigger.trigger 'beforeScroll.anchor'
        complete: =>
          $trigger.trigger 'afterScroll.anchor'

  ###
  @private
  @param e [Envet] event
  ###
  onClicked: (e) =>
    href = $(e.currentTarget).attr 'href'
    return if href.length is 0
    e.preventDefault()

    el =
      if href is '#' then 'html, body' else href
    @scroll el, @$trigger
