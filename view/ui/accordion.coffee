$ = require 'jquery'
_ = require 'lodash'
ToggleClass = require '../toggle-class'
ToggleAnime = require '../velocity/toggle-anime'
{ toggleDisplay } = require '../element-operation'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class Accordion

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    childSeletctor: '.js-accordion-child'
    btnSeletctor  : '.js-accordion-btn'
    cntSeletctor  : '.js-accordion-cnt'
    shownClass    : 'is-shown'
    animeOpts     :
      duration: 300
      easing  : 'easeOutCubic'

  ###
  create Accordion instance
  @param el [String|HTMLElement] element
  @param opts [Object] options
  ###
  constructor: (el, opts = {}) ->
    { @childSeletctor, @btnSeletctor, @cntSeletctor, @shownClass, @animeOpts } = _.defaultsDeep opts, defOpts

    @$wrap  = $ el
    @$child = @$wrap.find @childSeletctor
    @$btn   = @$child.find @btnSeletctor
      .on 'click', @$onBtnClicked
    @$cnt   = @$child.find @cntSeletctor

    ###
    create toggle class method
    ###
    @toggleClass = new ToggleClass @shownClass

    ###
    create veloctiy toggle animation method
    ###
    @toggleAnime = new ToggleAnime
      type: [ 'slideDown', 'slideUp' ]
      opts: @animeOpts

    toggleDisplay @$cnt, false

  ###
  @private
  ###
  onBtnClicked: (e) =>
    $btn = $ e.currentTarget
    $cnt = $btn.parent(@$child).find(@$cnt)

    toggle =
      if $cnt.is(':hidden') then true else false

    @toggleAnime.run toggle, { el: $cnt }
    @toggleClass.run toggle, $btn
