$ = require 'jquery'
_ = require 'lodash'
ToggleClass = require '../../operation/toggle-class'
ToggleAnime = require '../../velocity/operation/toggle-anime'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class ToggleBox

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    selectors:
      btn: '.js-toggle-box-btn'
      cnt: '.js-toggle-box-cnt'
    openClass: 'is-opened'

  ###
  create ToggleBox instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @selectors, @openClass } = _.defaultsDeep opts, defOpts

    @$wrap = $ el
    @$btn  = @$wrap.find @selectors.btn
      .on 'click', @onBtnClicked
    @$cnt  = @$wrap.find @selectors.cnt

    ###
    create toggle class method
    ###
    @toggleClass = new ToggleClass @openClass, @$wrap

    ###
    create velocity toggle animation method
    ###
    @toggleCnt = new ToggleAnime
      el  : @$cnt
      type: [ 'slideDown', 'slideUp' ]
      opts:
        duration: 300
        easing  : 'easeInOutSine'

  ###
  @private
  ###
  onBtnClicked: =>
    toggle = !@$wrap.hasClass @openClass

    @toggleCnt.run toggle
    @toggleClass.run toggle
