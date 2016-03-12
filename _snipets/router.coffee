$ = require 'jquery'
Backbone = require 'backbone'

###
@dependsOn jquery
@dependsOn backbone
###
module.exports =
class RouterSample extends Backbone.Router

  routes:
    '(index.html)'      : ''
    'page1/(index.html)': 'page1'
    'page2/(index.html)': 'page2'
    'page3/(index.html)': 'page3'

  ###
  create RouterSample instance
  ###
  constructor: ->
    super

    hasPushState = window.history and history.pushState
    pathname     = location.pathname.replace 'index.html', ''
    port         = location.port

    if !hasPushState and !location.hash
      location.href =
        if !port then "/##{pathname}" else "/index.html##{pathname}"

    $ 'a'
      .on 'click', (e) =>
        el  = e.currentTarget
        url = el.href
        return if url.indexOf(location.host) is -1
        e.preventDefault()
        $el   = $(el)
        href  = $el.attr 'href'
        delay = $el.data 'go-to-delay'
        setTimeout ->
          Backbone.history.navigate href, true
        , delay

  '': ->

  'page1': ->

  'page2': ->

  'page3': ->
