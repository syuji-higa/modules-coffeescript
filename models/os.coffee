Singleton = require '../pattern/singleton'

module.exports =
class OS extends Singleton

  R_I_PHONE        = /\((iphone).*?os ([\d_]+).*?\)/
  R_I_POD          = /\((ipod).*?os ([\d_]+).*?\)/
  R_I_PAD          = /\((ipad).*?os ([\d_]+).*?\)/
  R_ANDROID_MOBILE = /\(.*?(android) ([\d\.]+).*?\).*?(mobile)/
  R_ANDROID        = /\(.*?(android) ([\d\.]+).*?\)/
  R_WINDOWS_PHONE  = /\(.*?(windows phone).*?[OS]? ([\d\.]+).*?\)/
  R_BLACK_BERRY    = /.*?(blackberry).*?version\/([\d\.]+).*?/
  R_MAC            = /\(.*?(mac) os .*?([\d_\.]+).*?\)/
  R_LINUX          = /\(.*?(linux).*\)/
  R_WINDOWS        = /\(.*?(windows).*?([\d_\.]+).*?\)/

  constructor: ->
    super

    ua = window.navigator.userAgent.toLowerCase()

    [ {}, name, version, mobile ] =
      R_I_PHONE.exec(ua) or
      R_I_POD.exec(ua) or
      R_I_PAD.exec(ua) or
      R_ANDROID_MOBILE.exec(ua) or
      R_ANDROID.exec(ua) or
      R_WINDOWS_PHONE.exec(ua) or
      R_BLACK_BERRY.exec(ua) or
      R_MAC.exec(ua) or
      R_WINDOWS.exec(ua) or
      R_LINUX.exec(ua) or
      []

    if name
      @os      = name
      @version = version?.split('_').join('.') or ''
      number = parseInt @version, 10
      unless isNaN number
        @versionNumber = number
      @ios     = if name.match /iphone|iopd|ipad/ then true else false
      @androd  = if name.match /android/ then true else false
      @mobile  = do ->
        if name.match(/iphone|ipod|windows phone|blackberry/) or
           (name.match(/android/) and mobile)
          true
        else
          false
      @tablet  = do ->
        if name.match(/ipad/) or
           (name.match(/android/) and !mobile)
          true
        else
          false
