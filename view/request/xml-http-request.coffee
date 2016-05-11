$ = require 'jquery'
_ = require 'lodash'

###
@dependsOn jquery
@dependsOn lodash
###
module.exports =
class XMLHttpRequest

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    dataType: 'json'

  ###
  create XMLHttpRequest instance
  @param url [String] url
  @param opts [Object] options
  ###
  constructor: (url, opts = {}) ->
    @opts = _.defaults opts, defOpts
    @opts.url = url

  ###
  XML HTTP request
  @param opts [Object] options
  ###
  request: (opts = {}) ->
    opts = _.defaults opts, @opts
    dfd = $.Deferred()
    $.ajax opts
      .done (data) =>
        @success data
        dfd.resolve data
      .fail (err) =>
        @failure err
        dfd.reject err
      .always =>
        @complete()
    dfd.promise()

  ###
  request success
  @param data [Object] request data
  ###
  success: (data) ->

  ###
  request failure
  @param err [Object] request error information
  ###
  failure: (err) ->

  ###
  request complete
  ###
  complete: ->
