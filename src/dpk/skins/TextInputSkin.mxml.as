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
  border.radiusX = border.radiusY = getStyle('cornerRadius')
  borderStroke.color = getStyle('borderColor')
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}

