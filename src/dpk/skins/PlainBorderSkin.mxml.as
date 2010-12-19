import mx.core.EdgeMetrics

public function get backgroundImageBounds():Rectangle {
  return null
}

public function set backgroundImageBounds(value:Rectangle):void {
}

public function get borderMetrics():EdgeMetrics {
  return new EdgeMetrics(1, 1, 1, 1)
}

public function get hasBackgroundImage():Boolean {
  return false
}

public function layoutBackgroundImage():void {
}
