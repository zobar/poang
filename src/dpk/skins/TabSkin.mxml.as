override public function get contentItems():Array {
  return ['backgroundFill']
}

override protected function updateDisplayList(unscaledWidth:Number,
    unscaledHeight:Number):void {
  var cornerRadius:Number = getStyle('cornerRadius')
  var innerCornerRadius:Number = cornerRadius - 1
  highlightFillRect.topLeftRadiusX = highlightFillRect.topLeftRadiusY =
      highlightFillRect.topRightRadiusX = highlightFillRect.topRightRadiusY =
      cornerRadius - 2
  for each (var bg:Rect in [background, highlightStrokeRect]) {
    bg.topLeftRadiusX = bg.topLeftRadiusY = bg.topRightRadiusX =
        bg.topRightRadiusY = innerCornerRadius
  }
  border.topLeftRadiusX = border.topLeftRadiusY = border.topRightRadiusX =
      border.topRightRadiusY = cornerRadius
  dropShadow.topLeftRadiusX = dropShadow.topLeftRadiusY =
      dropShadow.topRightRadiusX = dropShadow.topRightRadiusY = cornerRadius + 1
  borderStroke.color = getStyle('borderColor')
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}
