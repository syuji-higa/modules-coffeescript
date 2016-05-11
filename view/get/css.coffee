_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =

  ###
  @param cssName [String] css name
  @return [String] css name
  ###
  getPrefixCssName: (cssName) ->
    decs = getComputedStyle document.head, ''
    _cssName = _.find decs, (dec) ->
      dec.match new RegExp("^(-webkit-|-moz-|-ms-|-o-)?#{cssName}$")
    if _cssName then _cssName else cssName

  ###
  @param $el [jQueryObject] element
  @return [String] background-image url
  ###
  getBgImg: ($el) ->
    bgImg = $el.css 'background-image'
    if bgImg isnt 'none'
      bgImg.match(/^url\(['"]?(.+[0-9a-zA-Z])['"]?\)$/)?[1]
