OS = require '../models/os'

module.exports =
class Redirect

  constructor: ->
    { @mobile } = OS.getInstance()

    return if @mobile

    protocol = location.protocol
    host     = location.host
    pathname = location.pathname

    return unless pathname.match /^\/sample\/sp/
    pcPathname = pathname.replace /^\/sample\/sp/, '/sample'

    location.href = "#{protocol}//#{host}#{pcPathname}"
