override protected function updateDisplayList(unscaledWidth:Number,
    unscaledHeight:Number):void {
  var borderColor:uint = getStyle('borderColor')
  var chromeColor:uint = getStyle('chromeColor')
  var cornerRadius:Number = getStyle('cornerRadius')
  if (border) {
    border.radiusX = border.radiusY = cornerRadius
    borderStroke.color = borderColor
  }
  if (borderSelected) {
    borderSelected.radiusX = borderSelected.radiusY = cornerRadius
    borderSelectedStroke.color = chromeColor
    borderTint.radiusX = borderTint.radiusY = cornerRadius
    borderTintStroke.color = borderColor
  }
  dropShadow.radiusX = dropShadow.radiusY = cornerRadius + 1
  if (highlightFill)
    highlightFill.color = chromeColor
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}
