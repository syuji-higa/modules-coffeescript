###
@dependsOn jquery
###
module.exports =
class ToggleClass

  ###
  create ToggleClass instance
  @param $el [jQueryObject] element
  @param className [String] class name
  ###
  constructor: (@className, @$el = null) ->

  ###
  @param toggle [Boolean] display set block or none
  @param $el [jQueryObject] element
  ###
  run: (toggle, $el = @$el) ->
    if toggle
      $el.addClass @className
    else
      $el.removeClass @className
