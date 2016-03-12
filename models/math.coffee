getRandom = (num, min = 0) ->
  Math.floor Math.random() * ((num - min) + 1) + min

module.exports =

  ###
  to angle
  ###
  toAngle: (num) ->
    (Math.PI / 180) * num

  ###
  get random
  ###
  getRandom: (num, min = 0) ->
    getRandom num, min

  getRandomDir: ->
    if getRandom(1) then 1 else -1

  ###
  get hypotenuse
  ###
  getHypotenuseFromBaAn: (base, angle) ->
    base / Math.sin(angle)

  getHypotenuseFromHeAn: (height, angle) ->
    height / Math.sin(angle)

  getHypotenuseFromBaHe: (base, height) ->
    Math.sqrt Math.pow(base, 2) + Math.pow(height, 2)

  ###
  get height
  ###
  getHeightFromBaAn: (base, angle) ->
    base * Math.tan(angle)

  getHeightFromHyAn: (hypotenuse, angle) ->
    hypotenuse * Math.sin(angle)

  getHeightFromBaHy: (base, hypotenuse) ->
    Math.sqrt Math.pow(hypotenuse, 2) - Math.pow(base, 2)

  ###
  get base
  ###
  getBaseFromHeAn: (height, angle) ->
    height / Math.tan(angle)

  getBaseFromHyAn: (hypotenuse, angle) ->
    hypotenuse * Math.cos(angle)

  getBaseFromHeHy: (height, hypotenuse) ->
    Math.sqrt Math.pow(hypotenuse, 2) - Math.pow(height, 2)

  ###
  get angle
  ###
  getAngleFromBaHe: (base, height) ->
    Math.atan2 height, base

  getAngleFromBaHy: (base, hypotenuse) ->
    Math.acos base / hypotenuse

  getAngleFromHeHy: (height, hypotenuse) ->
    Math.asin height / hypotenuse
