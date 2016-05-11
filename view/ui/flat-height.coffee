$ = require 'jquery'
_ = require 'lodash'
Elements = require '../elements'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class FlatHeight

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    groupName: 'group'
    column   : null

  ###
  create FlatHeight instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { groupName, column } = _.defaults opts, defOpts

    Elements.$window
      .on 'load', @onWindowLoaded

    @elms = {}

    _.forEach $(el), (el) =>
      $el = $ el
      group = $el.data(groupName)
      unless @elms[group]
        @elms[group] = []
      @elms[group].push $el

    return unless column

    @elmsClone = _.cloneDeep @elms
    @elms      = []
    count      = 0
    _.forEach @elmsClone, (elms) =>
      _.forEach elms, (el, i) =>
        unless @elms?[count]
          @elms[count] = []
        @elms[count].push $(el)
        unless (i + 1) % column
          count++

  ###
  @private
  ###
  onWindowLoaded: =>
    _.forEach @elms, (elms) =>
      tallest = 0
      _.forEach elms, ($el) =>
        tallest = Math.max tallest, $el.height()
      _.forEach elms, ($el) =>
        $el.height tallest
