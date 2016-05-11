###
@dependsOn jquery
###
module.exports =

  ###
  @param $el [jQueryObject] element
  @param toggle [Boolean] display set block or none
  ###
  toggleDisplay: ($el, toggle) ->
    display =
      if toggle then 'block' else 'none'
    $el.css 'display', display

  ###
  @param $el [jQueryObject] element
  @param fn [function] function to execute between
  ###
  displayMoment: ($el, fn) ->
    $el.css 'display', 'block'
    fn()
    $el.css 'display', 'none'
