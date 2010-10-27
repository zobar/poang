override public function get colorizeExclusions():Array {
  return ['background', 'border', 'highlight', 'labelDisplay', 'overHighlight']
}

override protected function updateDisplayList(unscaledWidth:Number,
    unscaledHeight:Number):void {
  var cornerRadius:Number = getStyle('cornerRadius')
  border.radiusX = border.radiusY = cornerRadius
  dropShadow.radiusX = dropShadow.radiusY = cornerRadius + 1
  borderStroke.color = getStyle('borderColor')
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}
