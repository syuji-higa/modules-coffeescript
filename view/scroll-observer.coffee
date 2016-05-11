{ getRect } = require '../../../../models/rect'

module.exports =
class ScrollObserver

  elms:
    sampleClass: 'js-sample'

  constructor: ->
    @$sample = document.getElementsByClassName(@elms.sampleClass)[0]

    @reset()

    window.addEventListener('scroll', @observe.bind(this), false)
    window.addEventListener('resize', @reset.bind(this), false)

  observe: =>
    winScrollY_ = window.pageYOffset;

    console.log(winScrollY_)

    if @samplePoint.top < scrollY_
      console.log('sample')

  reset: =>
    @samplePoint = getRect(@$sample)
