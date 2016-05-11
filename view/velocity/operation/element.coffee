_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =

  ###
  @param $el [jQueryObject] element
  @param css [Object] css
  ###
  setCss: ($el, css) ->
    $el.velocity css, { duration: 0 }
