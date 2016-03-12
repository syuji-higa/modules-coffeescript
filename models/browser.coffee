module.exports =
class Browser

  R_CHROME = /(chrome)[ \/]([\w.]+)/
  R_WEBKIT = /(webkit)[ \/]([\w.]+)/
  R_OPERA = /(opera)(?:.*version|)[ \/]([\w.]+)/
  R_MSIE = /(msie) ([\w.]+)/
  R_MOZILLA = /(mozilla)(?:.*? rv:([\w.]+)|)/

  constructor: (ua = window.navigator.userAgent) ->
    return new Browser ua unless @ instanceof Browser

    ua = ua.toLowerCase()

    [ {}, name, version ] =
      R_CHROME.exec(ua) or
      R_WEBKIT.exec(ua) or
      R_OPERA.exec(ua) or
      R_MSIE.exec(ua) or
      ua.indexOf("compatible") < 0 and R_MOZILLA.exec(ua) or
      []

    if name
      @[name] = true
      @version = version
      number = parseInt @version, 10
      unless isNaN number
        @versionNumber = number
    if @chrome
      @webkit = true
    else if @webkit
      @safari = true
