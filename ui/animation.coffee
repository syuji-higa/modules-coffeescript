$ = require 'jquery'
AnimationSequence = require '../velocity/animation-sequence'
SplashSequence = require './animation-sequence/splash-sequence'

###
@dependsOn jquery
@dependsOn velocity
###
module.exports =
class Animation

  ###
  create Animation instance
  ###
  constructor: ->
    { @getInitialVals, @getSequences } = new SplashSequence
    { @initialize, @runSequence } = new AnimationSequence
    @initialize @getInitialVals()
    @runSequence @getSequences(), 'name',
      begin: =>
        console.log 'begin'
      complete: =>
        console.log 'complete'
