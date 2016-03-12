{ parse } = require './query-string'

getQuery = ->
  location.search.replace '?', ''
  # location.hash.match(/^.*\?(.*)$/)?[1]  # get hash in params

module.exports =

  ###
  @return [String] query string
  ###
  getQuery: ->
    getQuery()

  ###
  @return [String] query string
  ###
  toParams: (query) ->
    if query then parse(query) else {}

  ###
  @return [Object] query object
  ###
  getParams: ->
    query = getQuery()
    if query then parse(query) else {}

  ###
  @return [Object] query object
  ###
  getParam: (name, query = null) ->
    query = getQuery() unless query
    parse(query)?[name] if query
