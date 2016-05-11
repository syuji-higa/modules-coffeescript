$ = require 'jquery'

module.exports =
class splahsSequence

  constructor: ->
    @$sample1 = $ '.sample-1'
    @$sample2 = $ '.sample-2'

  getInitialVals: =>
    [
      {
        e: '.sample-1, .sample-2'
        p: { display: 'none' }
      }
      {
        e: @$sample1.add @sample2
        p: { visibility: 'hidden' }
      }
    ]

  getSequences: =>
    {
      splash: [
        {
          e: @$sample
          p: opacity   : [ 1, 0 ]
          o: { duration: 300, display: 'block' }
        }
        {
          e: @$heading.eq 1
          p:
            opacity   : [ 1, 0 ]
            translateX: [ 0, 'easeOutSine', -200 ]
          o: { duration: 300, display: 'block', delay: 200, sequenceQueue: false }
        }
      ]
    }
