import mx.utils.ColorUtil

override public function get contentItems():Array {
  return ['backgroundFill']
}

override protected function commitProperties():void {
  super.commitProperties()
  textDisplay.setStyle('paddingBottom', getStyle('paddingBottom'))
  textDisplay.setStyle('paddingLeft', getStyle('paddingLeft'))
  textDisplay.setStyle('paddingRight', getStyle('paddingRight'))
  textDisplay.setStyle('paddingTop', getStyle('paddingTop'))
}

override protected function updateDisplayList(unscaledWidth:Number,
    unscaledHeight:Number):void {
  var borderColor:uint = getStyle('borderColor')
  var borderDarkColor:uint = ColorUtil.adjustBrightness(borderColor, -26)
  var borderLightColor:uint = ColorUtil.adjustBrightness(borderColor, 25)
  borderDarkStroke.color = borderDarkColor
  borderLightStroke.color = borderLightColor
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}
