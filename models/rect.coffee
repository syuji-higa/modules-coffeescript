module.exports = do ->

  winY_ = 0
  winX_ = 0

  reset_ = ->
    winY_ = window.pageYOffset
    winX_ = window.pageXOffset

  getRect_ = (_$el) ->
    rect_ = _$el.getBoundingClientRect()
    {
      width : rect_.width
      height: rect_.height
      top   : rect_.top    + winY_
      right : rect_.right  + winX_
      bottom: rect_.bottom + winY_
      left  : rect_.left   + winX_
    }

  {
    getRect: (_$el) ->
      reset_()
      getRect_(_$el)

    getRects: (_$$el) ->
      reset_()
      _.map(_$$el, (_$el) ->
        getRect_(_$el);
      )
  }
