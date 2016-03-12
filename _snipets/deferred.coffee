$ = require 'jquery'

###
@dependsOn jquery
###
module.exports =
class DeferredSample

  ###
  create DeferredSample instance
  ###
  constructor: ->
    dfd = $.Deferred()
    dfd
      .then =>
        setTimeout =>
          console.log '1'
        , 1000
      .then =>
        setTimeout =>
          console.log '2'
        , 1000
      .then =>
        setTimeout =>
          console.log '3'
        , 1000
    dfd.resolve()
