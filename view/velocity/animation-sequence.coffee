$ = require 'jquery'
_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class AnimationSequence

  ###
  create AnimationSequence instance
  ###
  constructor: ->
    @playLoop = {}

  ###
  initialize
  @param initialVals [Array] animation initial vals

  @example initialVals array
    [
      {
        e: '.sapmle'
        p: { display: 'none' }
      }
    ]
  ###
  initialize: (initialVals) =>
    return unless initialVals
    _.forEach initialVals, (obj) =>
      @getJqueryObj obj.e
        .css obj.p

  ###
  animation sequence
  @param sequences [object] animation sequences
  @param name [String] sequence name
  @param opts [object] before and after function

  @example sequences object
    {
      name: [
        {
          e: '.sample'
          p: { opacity: 1 }
          o: { duration: 500, display: 'block' }
        }
      ]
    }
  ###
  runSequence: (sequences, name, opts = {}) =>
    defOpts =
      begin   : null
      complete: null

    { begin, complete } = _.defaults opts, defOpts

    return unless sequences
    len = sequences[name].length
    unless len
      begin?()
      complete?()
      return
    $.Velocity.RunSequence _.map sequences[name], (obj, i) =>
      _obj =
        elements  : @getJqueryObj obj.e
        properties: obj.p
        options   : obj.o
      if i is 0
        _obj.options.begin = begin
      if (len - 1) is i
        _obj.options.complete = complete
      _obj

  ###
  loop animation sequence
  @param sequences [object] animation sequences
  @param names [Array] sequence names
  @param interval [Number] sequence interval
  ###
  loopSequences: (sequences, names, interval = 0) =>
    timer = {}
    _.forEach names, (name) =>
      @playLoop[name] = true
    runSequences = (sequences, names, interval) =>
      _.forEach names, (name) =>
        clearTimeout timer?[name]
        if @playLoop[name]
          timer[name] = setTimeout =>
            @runSequence sequences, name,
              complete: =>
                runSequences sequences, names, interval
          , interval
    runSequences sequences, names, interval

  ###
  @private
  @param el [String|jQueryObject|HTMLElement|Array] element
  ###
  getJqueryObj: (el) ->
    if el instanceof jQuery then el else $(el)
