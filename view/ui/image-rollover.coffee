$ = require 'jquery'
_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class ImageRollover

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    offSuffix: '-out'
    onSuffix : '-hover'

  ###
  create ImageRollover instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @offSuffix, @onSuffix } = _.defaults opts, defOpts

    return unless el.src.match(new RegExp("^.*#{ @offSuffix }\.[a-z]+$"))

    @$el = $ el
      .on
        'mouseover': => @change @$el, @offSuffix, @onSuffix
        'mouseout' : => @change @$el, @onSuffix, @offSuffix

    @change $('<img>'), @offSuffix, @onSuffix

  ###
  @private
  @param $img [jQueryObject] image element
  @param beforeSuffix [String] before suffix
  @param afterSuffix [String] after suffix
  ###
  change: ($img, beforeSuffix, afterSuffix) =>
    afterSrc = @$el
      .attr 'src'
      .replace(new RegExp("^(\.+)#{ beforeSuffix }(\\.[a-z]+)$"), "$1#{ afterSuffix }$2")
    $img.attr 'src', afterSrc
