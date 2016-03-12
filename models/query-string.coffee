_ = require 'lodash'

module.exports =

  parse: (str, sep = '&', eq = '=') ->
    obj = {}
    _.forEach String(str).split(sep), (param) ->
      [key, val] = param.split eq
      obj[key] = val
    obj
