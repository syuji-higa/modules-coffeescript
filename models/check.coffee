module.exports =

  ###
  @param arg [Object|String] json
  @return [boolean] is json
  ###
  isJson: (arg) ->
    arg = if (typeof(arg) is 'function') then arg() else arg
    return false if typeof(arg) isnt 'string'
    try
      arg = if !JSON then eval("(" + arg + ")") else JSON.parse(arg)
      return true
    catch e
      return false
