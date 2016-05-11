{ getBgImg } = require('../../get/css')
OS = require('../../models/os')

module.exports =
class SpriteAnimate

  defOpts =
    fps : 30
    loop: true

  constructor: (_$el, _opts = {}) ->
    { fps, @loop } = _.defaults(_opts, defOpts)

    { version, android } = OS.getInstance()

    return if(android && (4.4 > Number(version.slice(0, 3))))

    @$wrap = _$el

    if jQuery(@$wrap).data('sprite-fps')
      fps = jQuery(@$wrap).data('sprite-fps')

    @ms         = 1000 / fps
    @startTime  = 0
    @animation  = false
    @rate       = 1
    @frame      = null
    @index      = 0
    @spriteName = jQuery(@$wrap).data('sprite-name')

    @wrapW = @$wrap.clientWidth
    @wrapH = @$wrap.clientHeight

    rendererOpts = [ @wrapW, @wrapH, { transparent: true } ]
    @stage = new PIXI.Container
    @renderer = null
    # @renderer = new PIXI.autoDetectRenderer(...rendererOpts)
    @renderer = new PIXI.CanvasRenderer(rendererOpts...)
    @sprite = null

    @$wrap.appendChild(@renderer.view)

    PIXI.loader
    .add(@spriteName, getBgImg(jQuery(@$wrap)))
    .load(@imageLoaded.bind(this))

  start: ->
    @animation = true
    @animate()

  stop: ->
    @animation = false

  reset: =>
    @wrapW = @$wrap.clientWidth
    @wrapH = @$wrap.clientHeight
    @renderer.resize(@wrapW, @wrapH)

    @rate = @wrapW / @sprite.texture.width

    @stage.scale.x = @rate
    @stage.scale.y = @rate

    @renderer.render(@stage);

  imageLoaded: (_loader, _resources) =>

    @$wrap.style.background = 'none'

    @sprite = new PIXI.Sprite(_resources[@spriteName].texture)

    @reset()

    @frame = Math.round((@sprite.height * @rate) / @wrapH)

    @stage.addChild(@sprite)

    @renderer.render(@stage)

    window.addEventListener('resize', @reset.bind(this))

  animate: =>
    return if(!@animation)

    if(@ms >= (new Date().getTime() - @startTime))
      requestAnimationFrame(@animate.bind(this))
      return

    requestAnimationFrame(@animate.bind(this))
    @startTime = new Date().getTime()

    if((@frame - 1) > @index)
      @sprite.position.y -= (@sprite.height / @frame)
      @index++
    else
      if(@loop)
        @sprite.position.y = 0
        @index = 0
      else
        @stop()
        return

    @renderer.render(@stage)
