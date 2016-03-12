$ = require 'jquery'

module.exports =
class AnimeSample

  ###
  create AnimeSample instance
  ###
  constructor: ->
    @isAnime = false

  ###
  @private
  is animation
  ###
  startAnime: ->
    if @isAnime then return else @isAnime = true
  endAnime: ->
    @isAnime = false
