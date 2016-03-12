OS = require '../models/os'

module.exports =
class Redirect

  constructor: ->
    { @mobile } = OS.getInstance()

    return unless @mobile

    protocol = location.protocol
    host     = location.host
    pathname = location.pathname

    return unless pathname.match /^\/sample/
    spPathname = pathname.replace /^\/sample/, '/sample/sp'

    location.href = "#{protocol}//#{host}#{spPathname}"
