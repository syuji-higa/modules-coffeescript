module.exports =

  ###
  get Function.name
  for IE
  @param fn [Function] faunction name
  ###
  getFunctionName: (fn) ->
    if fn.name
      fn.name
    else
      fn.toString().match(/^function\s*([^\s(]+)/)[1]
