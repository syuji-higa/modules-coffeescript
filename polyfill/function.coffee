
###
name member polyfill
for IE9+
###
if !Function.name
  Object.defineProperty Function::, 'name',
    get: ->
      @.toString().match(/^function\s*([^\s(]+)/)[1]
