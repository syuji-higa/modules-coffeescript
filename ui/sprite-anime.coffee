$ = require 'jquery'
Elements = require './elements'
Loader = require './loader'
{ find, defaults } = require 'lodash'
{ getBgImg } = require '../../components/css-val'

module.exports =
class SpriteAnime

  defOpts =
    fps     : 30
    loop    : false
    sprites : null
    isRetina: false

  constructor: (@el, opts = {}) ->
    { @fps, @loop, @sprites, @isRetina } = defaults opts, defOpts

    @$window = Elements.$window
      .one
        'pagesLoaded' : @onPagesLoaded
        'imagesLoaded': @onImagesLoaded

    @requestId = null

  onPagesLoaded: =>
    @$el = $ @el

    @viewH = @$el.height()
    @src   = getBgImg @$el

  onImagesLoaded: =>
    imageData = find Loader.imagesData, (data) =>
      @src is data.src
    @frame = imageData.height / @viewH
    @frame / 2 if @isRetina

  start: (opts = {}) ->
    defStartOpts =
      skip: false
      th  : 0
      cb  : null
      ms  : 1000 / @fps

    { skip, th, cb, ms } = defaults opts, defStartOpts

    if @sprites
      sprite  = @sprites[th]
      @startY = sprite[0]
      @endY   = sprite[sprite.length - 1]
      @y =
        if !skip then @startY else @endY
    else
      @startY = 0
      @endY   = @frame - 1
      @y =
        if !skip then 0 else (@frame - 1)

    @startTime = new Date().getTime()
    @cb = cb
    @timer ms

  end: ->
    window.cancelAnimationFrame @requestId

  timer: (ms) =>
    status = new Date().getTime() - @startTime
    if ms < status
      @$el.css 'background-position', "0 #{-@viewH * @y}px"
      @startTime = new Date().getTime()
      @y++
    if @endY >= @y
      @requestId = window.requestAnimationFrame => @timer(ms)
    else
      if @loop
        @startTime = new Date().getTime()
        @y = @startY
        @requestId = window.requestAnimationFrame => @timer(ms)
      @cb() if @cb
