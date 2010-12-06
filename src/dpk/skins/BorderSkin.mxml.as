import mx.core.EdgeMetrics

public function get backgroundImageBounds():Rectangle {
  return null
}

public function set backgroundImageBounds(value:Rectangle):void {
}

public function get borderMetrics():EdgeMetrics {
  return new EdgeMetrics(1, 1, 1, 1)
}

override public function get contentItems():Array {
  return ['backgroundFill']
}

public function get hasBackgroundImage():Boolean {
  return false
}

public function layoutBackgroundImage():void {
}

override protected function updateDisplayList(unscaledWidth:Number,
    unscaledHeight:Number):void {
  var cornerRadius:Number = getStyle('cornerRadius')
  border.radiusX = border.radiusY = cornerRadius
  dropShadow.radiusX = dropShadow.radiusY = cornerRadius + 1
  borderStroke.color = getStyle('borderColor')
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}
