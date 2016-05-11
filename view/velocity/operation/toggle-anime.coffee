_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class ToggleAnime

  ###
  @private
  @property [Object] default options
  ###
  defCmnOpts =
    el        : null
    type      : [{},{}]
    removeType: 'display'
    opts      : {}

  ###
  create ToggleAnime instance
  @param cmnOpts [Object] css or anime taype and velocity options
  ###
  constructor: (cmnOpts = {}) ->
    { @el, @type, @removeType, @opts } = _.defaults cmnOpts, defCmnOpts

  ###
  @param toggle [Boolean] display set show or hide
  @param caseOpts [Object] veloctiy optoins
  ###
  run: (toggle, caseOpts = {}) =>
    defCaseOpts =
      el  : @el
      opts: @opts
      type: if toggle then @type[0] else @type[1]

    { el, type, opts } = _.defaultsDeep caseOpts, defCaseOpts

    _opts = _.clone opts

    if typeof type isnt 'string'
      switch @removeType
        when 'display'
          _opts.display =
            if toggle then 'block' else 'none'
        when 'visibility'
          _opts.visibility =
            if toggle then 'visible' else 'hidden'

    el
      .velocity 'stop'
      .velocity type, _opts
