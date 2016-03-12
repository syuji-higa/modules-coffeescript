$ = require 'jquery'
_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class Elements

  @selectors:
    window  : window
    document: document
    html    : 'html'
    body    : 'body'

  ###
  create Elements instance
  ###
  constructor: ->
    _.forEach Elements.selectors, (selector, name) ->
      selectorName = "$#{name}"
      Elements[selectorName] = $ selector
