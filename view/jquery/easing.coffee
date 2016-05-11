{
  PI
  abs
  pow
  sqrt
  sin
  cos
  asin
  round
} = Math

PI_2 = PI / 2

roundSmall = (val) ->
#    return 0 if val is 0
#    return val if val >= 1e-6 or val <= -1e-6
#    return 1e-6 if val >= 5e-7
#    return -1e-6 if val <= -5e-7
#    0
  return val if val >= 1e-6
  round(val * 1000000) / 1000000

factory =

  linear: ->
    (x, t, b, c, d) ->
      c * t / d + b

  easeInBack: (s) ->
    s = s or 1.70158
    (x, t, b, c, d) ->
      c * (t /= d) * t * ((s + 1) * t - s) + b

  easeInOutBack: (s) ->
    s = s or 1.70158
    (x, t, b, c, d) ->
      return c / 2 * (t * t * (((s * 1.525) + 1) * t - s * 1.525)) + b  if (t /= d / 2) < 1
      c / 2 * ((t -= 2) * t * (((s * 1.525) + 1) * t + s * 1.525) + 2) + b

  easeOutBack: (s) ->
    s = s or 1.70158
    (x, t, b, c, d) ->
      c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b

  easeOutInBack: (s) ->
    s = s or 1.70158
    (x, t, b, c, d) ->
      return (c / 2) * ((t = (t * 2) / d - 1) * t * ((s + 1) * t + s) + 1) + b  if t < d / 2
      (c / 2) * (t = (t * 2 - d) / d) * t * ((s + 1) * t - s) + (b + c / 2)

  easeInBounce: ->
    (x, t, b, c, d) ->
      return c - (c * (7.5625 * t * t)) + b  if (t = (d - t) / d) < 0.36363636363636365
      return c - (c * (7.5625 * (t -= 0.5454545454545454) * t + 0.75)) + b  if t < 0.7272727272727273
      return c - (c * (7.5625 * (t -= 0.8181818181818182) * t + 0.9375)) + b  if t < 0.9090909090909091
      c - (c * (7.5625 * (t -= 0.9545454545454546) * t + 0.984375)) + b

  easeInOutBounce: ->
    (x, t, b, c, d) ->
      if t < d / 2
        return (c - (c * (7.5625 * t * t))) * 0.5 + b  if (t = (d - t * 2) / d) < 0.36363636363636365
        return (c - (c * (7.5625 * (t -= 0.5454545454545454) * t + 0.75))) * 0.5 + b  if t < 0.7272727272727273
        return (c - (c * (7.5625 * (t -= 0.8181818181818182) * t + 0.9375))) * 0.5 + b  if t < 0.9090909090909091
        (c - (c * (7.5625 * (t -= 0.9545454545454546) * t + 0.984375))) * 0.5 + b
      else
        return (c * (7.5625 * t * t)) * 0.5 + c * 0.5 + b  if (t = (t * 2 - d) / d) < 0.36363636363636365
        return (c * (7.5625 * (t -= 0.5454545454545454) * t + 0.75)) * 0.5 + c * 0.5 + b  if t < 0.7272727272727273
        return (c * (7.5625 * (t -= 0.8181818181818182) * t + 0.9375)) * 0.5 + c * 0.5 + b  if t < 0.9090909090909091
        (c * (7.5625 * (t -= 0.9545454545454546) * t + 0.984375)) * 0.5 + c * 0.5 + b

  easeOutBounce: ->
    (x, t, b, c, d) ->
      return c * (7.5625 * t * t) + b  if (t /= d) < 0.36363636363636365
      return c * (7.5625 * (t -= 0.5454545454545454) * t + 0.75) + b  if t < 0.7272727272727273
      return c * (7.5625 * (t -= 0.8181818181818182) * t + 0.9375) + b  if t < 0.9090909090909091
      c * (7.5625 * (t -= 0.9545454545454546) * t + 0.984375) + b

  easeOutInBounce: ->
    (x, t, b, c, d) ->
      if t < d / 2
        return (c / 2) * (7.5625 * t * t) + b  if (t = (t * 2) / d) < 0.36363636363636365
        return (c / 2) * (7.5625 * (t -= 0.5454545454545454) * t + 0.75) + b  if t < 0.7272727272727273
        return (c / 2) * (7.5625 * (t -= 0.8181818181818182) * t + 0.9375) + b  if t < 0.9090909090909091
        (c / 2) * (7.5625 * (t -= 0.9545454545454546) * t + 0.984375) + b
      else
        return (c / 2) - ((c / 2) * (7.5625 * t * t)) + (b + c / 2)  if (t = (d - (t * 2 - d)) / d) < 0.36363636363636365
        return (c / 2) - ((c / 2) * (7.5625 * (t -= 0.5454545454545454) * t + 0.75)) + (b + c / 2)  if t < 0.7272727272727273
        return (c / 2) - ((c / 2) * (7.5625 * (t -= 0.8181818181818182) * t + 0.9375)) + (b + c / 2)  if t < 0.9090909090909091
        (c / 2) - ((c / 2) * (7.5625 * (t -= 0.9545454545454546) * t + 0.984375)) + (b + c / 2)

  easeInCirc: ->
    (x, t, b, c, d) ->
      -c * (sqrt(1 - (t /= d) * t) - 1) + b

  easeInOutCirc: ->
    (x, t, b, c, d) ->
      return -c / 2 * (sqrt(1 - t * t) - 1) + b  if (t /= d / 2) < 1
      c / 2 * (sqrt(1 - (t -= 2) * t) + 1) + b

  easeOutCirc: ->
    (x, t, b, c, d) ->
      c * sqrt(1 - (t = t / d - 1) * t) + b

  easeOutInCirc: ->
    (x, t, b, c, d) ->
      return (c / 2) * sqrt(1 - (t = (t * 2) / d - 1) * t) + b  if t < d / 2
      -(c / 2) * (sqrt(1 - (t = (t * 2 - d) / d) * t) - 1) + (b + c / 2)

  easeInCubic: ->
    (x, t, b, c, d) ->
      c * (t /= d) * t * t + b

  easeInOutCubic: ->
    (x, t, b, c, d) ->
      (if ((t /= d / 2) < 1) then c / 2 * t * t * t + b else c / 2 * ((t -= 2) * t * t + 2) + b)

  easeOutCubic: ->
    (x, t, b, c, d) ->
      c * ((t = t / d - 1) * t * t + 1) + b

  easeOutInCubic: ->
    (x, t, b, c, d) ->
      (if t < d / 2 then c / 2 * ((t = t * 2 / d - 1) * t * t + 1) + b else c / 2 * (t = (t * 2 - d) / d) * t * t + b + c / 2)

  easeInElastic: (a, p) ->
    a = a or 0
    p = p or 0
    (x, t, b, c, d) ->
      s = undefined
      return b  if t is 0
      return b + c  if (t /= d) is 1
      p = d * 0.3  unless p
      if not a or a < abs(c)
        a = c
        s = p / 4
      else
        s = p / (2 * PI) * asin(c / a)
      -(a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * PI) / p)) + b

  easeInOutElastic: (a, p) ->
    a = a or 0
    p = p or 0
    (x, t, b, c, d) ->
      s = undefined
      return b  if t is 0
      return b + c  if (t /= d / 2) is 2
      p = d * (0.3 * 1.5)  unless p
      if not a or a < abs(c)
        a = c
        s = p / 4
      else
        s = p / (2 * PI) * asin(c / a)
      return -0.5 * (a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * PI) / p)) + b  if t < 1
      a * pow(2, -10 * (t -= 1)) * sin((t * d - s) * (2 * PI) / p) * 0.5 + c + b

  easeOutElastic: (a, p) ->
    a = a or 0
    p = p or 0
    (x, t, b, c, d) ->
      s = undefined
      return b  if t is 0
      return b + c  if (t /= d) is 1
      p = d * 0.3  unless p
      if not a or a < abs(c)
        a = c
        s = p / 4
      else
        s = p / (2 * PI) * asin(c / a)
      a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b

  easeOutInElastic: (a, p) ->
    a = a or 0
    p = p or 0
    (x, t, b, c, d) ->
      s = undefined
      c /= 2
      if t < d / 2
        return b  if (t *= 2) is 0
        return b + c  if (t /= d) is 1
        p = d * 0.3  unless p
        if not a or a < abs(c)
          a = c
          s = p / 4
        else
          s = p / (2 * PI) * asin(c / a)
        a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b
      else
        return (b + c)  if (t = t * 2 - d) is 0
        return (b + c) + c  if (t /= d) is 1
        p = d * 0.3  unless p
        if not a or a < abs(c)
          a = c
          s = p / 4
        else
          s = p / (2 * PI) * asin(c / a)
        -(a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * PI) / p)) + (b + c)

  easeInExpo: ->
    (x, t, b, c, d) ->
      (if t is 0 then b else c * pow(2, 10 * (t / d - 1)) + b)

  easeInOutExpo: ->
    (x, t, b, c, d) ->
      return b  if t is 0
      return b + c  if t is d
      return c / 2 * pow(2, 10 * (t - 1)) + b  if (t /= d / 2) < 1
      c / 2 * (2 - pow(2, -10 * --t)) + b

  easeOutExpo: ->
    (x, t, b, c, d) ->
      return b + c  if t is d
      c * (1 - pow(2, -10 * t / d)) + b

  easeOutInExpo: ->
    (x, t, b, c, d) ->
      return (if t * 2 is d then b + c / 2 else c / 2 * (1 - pow(2, -10 * t * 2 / d)) + b)  if t < d / 2
      (if (t * 2 - d) is 0 then b + c / 2 else c / 2 * pow(2, 10 * ((t * 2 - d) / d - 1)) + b + c / 2)

  easeInQuad: ->
    (x, t, b, c, d) ->
      c * (t /= d) * t + b

  easeInOutQuad: ->
    (x, t, b, c, d) ->
      return c / 2 * t * t + b  if (t /= d / 2) < 1
      -c / 2 * ((--t) * (t - 2) - 1) + b

  easeOutQuad: ->
    (x, t, b, c, d) ->
      -c * (t /= d) * (t - 2) + b

  easeOutInQuad: ->
    (x, t, b, c, d) ->
      return -(c / 2) * (t = (t * 2 / d)) * (t - 2) + b  if t < d / 2
      (c / 2) * (t = (t * 2 - d) / d) * t + (b + c / 2)

  easeInQuart: ->
    (x, t, b, c, d) ->
      c * (t /= d) * t * t * t + b

  easeInOutQuart: ->
    (x, t, b, c, d) ->
      return c / 2 * t * t * t * t + b  if (t /= d / 2) < 1
      -c / 2 * ((t -= 2) * t * t * t - 2) + b

  easeOutQuart: ->
    (x, t, b, c, d) ->
      -c * ((t = t / d - 1) * t * t * t - 1) + b

  easeOutInQuart: ->
    (x, t, b, c, d) ->
      return -(c / 2) * ((t = (t * 2) / d - 1) * t * t * t - 1) + b  if t < d / 2
      (c / 2) * (t = (t * 2 - d) / d) * t * t * t + (b + c / 2)

  easeInQuint: ->
    (x, t, b, c, d) ->
      c * (t /= d) * t * t * t * t + b

  easeInOutQuint: ->
    (x, t, b, c, d) ->
      return c / 2 * t * t * t * t * t + b  if (t /= d / 2) < 1
      c / 2 * ((t -= 2) * t * t * t * t + 2) + b

  easeOutQuint: ->
    (x, t, b, c, d) ->
      c * ((t = t / d - 1) * t * t * t * t + 1) + b

  easeOutInQuint: ->
    (x, t, b, c, d) ->
      return (c / 2) * ((t = (t * 2) / d - 1) * t * t * t * t + 1) + b  if t < d / 2
      (c / 2) * (t = (t * 2 - d) / d) * t * t * t * t + (b + c / 2)

  easeInSine: ->
    (x, t, b, c, d) ->
      -c * cos(t / d * (PI_2)) + c + b

  easeInOutSine: ->
    (x, t, b, c, d) ->
      -c / 2 * (cos(PI * t / d) - 1) + b

  easeOutSine: ->
    (x, t, b, c, d) ->
      c * sin(t / d * (PI_2)) + b

  easeOutInSine: ->
    (x, t, b, c, d) ->
      return (c / 2) * sin((t * 2) / d * (PI_2)) + b  if t < d / 2
      -(c / 2) * cos((t * 2 - d) / d * (PI_2)) + (c / 2) + (b + c / 2)

module.exports =

  factory: factory

  jquerize: ($) ->
    return if $.jquerized?['easing']

    $.extend $.easing, do ->
      easing = {}
      for name, func of factory
        ease = func()
        do (ease) ->
          easing[name] = ->
            roundSmall ease.apply @, arguments
      easing.ease = easing.easeOutQuad
      easing

    $.jquerized ?= {}
    $.jquerized['easing'] = true
