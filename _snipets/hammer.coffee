$ = require 'jquery'
_ = require 'lodash'
Hammer = require 'hammerjs'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class HammerSample

  ###
  create HammerSample instance
  ###
  constructor: ->
    new Hammer 'a'
      .on 'tap', @onTaped

    _.forEach $('.sample'), (el) =>
      new Hammer el
        .on 'tap', =>
          console.log 'tap'

  ###
  @private
  ###
  onTaped: (e) =>
    $self = $ e.srcEvent.currentTarget
