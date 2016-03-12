$ = require 'jquery'
_ = require 'lodash'
require('../../jquery/easing').jquerize $

###
@dependsOn jquery
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

    @$target  = $ 'html, body'
    @$trigger = $ el
      .on 'click', @onClicked

  ###
  @param y [Number] target position
  @param $trigger [jQueryObject] trigger element
  @param opts [Object] options
  ###
  scroll: (y, $trigger, opts = {}) ->
    unless @duration or @easing or @offset
      { @duration, @easing, @offset } = _.defaults opts, defOpts

    $trigger.trigger 'beforeScroll.anchor'
    @$target
      .animate
        scrollTop: y + @offset
      , @duration, @easing, =>
        $trigger.trigger 'afterScroll.anchor'

  ###
  @private
  @param e [Envet] event
  ###
  onClicked: (e) =>
    href = $(e.currentTarget).attr 'href'
    return if href.length is 0
    e.preventDefault()

    y =
      if href is '#' then 0 else $(href).offset().top
    @scroll y, @$trigger
