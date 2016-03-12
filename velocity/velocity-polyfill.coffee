$ = require 'jquery'
_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
@dependsOn velocity
###
module.exports =
class VelocityPolyfill

  ###
  create VelocityPolyfill instance
  ###
  constructor: ->

    ###
    end in the case of has velocity method
    ###
    return if $.fn.velocity?

    $.fn.extend
      velocity: (type, opts) ->
        _opts = _.filter opts, (val, key) ->
          key and (key isnt 'begin')
        opts.begin() if opts.begin?
        if typeof type is 'string'
          $.fn[type].apply @, _opts
        else
          _opts.unshift type
          $.fn.animate.apply @, _opts
