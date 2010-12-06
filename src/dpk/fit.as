package dpk {
  import flash.geom.Matrix
  import flash.geom.Rectangle

  public function fit(rect:Rectangle, bounds:Rectangle):Matrix {
    var scale:Number = Math.min(bounds.width / rect.width,
        bounds.height / rect.height)
    var w:Number = rect.width * scale
    var h:Number = rect.height * scale
    var tx:Number = (bounds.width - w) / 2
    var ty:Number = (bounds.height - h) / 2
    return new Matrix(scale, 0, 0, scale, tx, ty)
  }
}
