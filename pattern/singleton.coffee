module.exports =
class Singleton

  ###
  @private
  ###
  instance   = []
  isInternal = []

  ###
  @static
  ###
  @getInstance: ->
    name = @.name
    return instance[name] if instance[name]?
    isInternal[name] = true
    new @

  ###
  create Singleton instance
  ###
  constructor: ->
    name = @constructor.name
    unless isInternal[name]
      throw new Error "Can't call new #{name}(), use #{name}.getInstance() instead."
    isInternal[name] = false
    instance[name]   = @
