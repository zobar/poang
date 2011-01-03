package framsta {
  import dpk.fit
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.Sprite
  import flash.geom.Rectangle

  public class Placeholder extends Sprite {
    protected var bitmap:Bitmap

    public function get bitmapData() {
      return bitmap.bitmapData
    }
    public function set bitmapData(value:BitmapData):void {
      bitmap.bitmapData = value
      if (value) {
        bitmap.transform.matrix = fit(new Rectangle(0, 0, value.width,
            value.height), bounds)
      }
    }

    protected var bounds:Rectangle

    public function Placeholder() {
      bounds = getBounds(this)
      graphics.clear()
      while (numChildren)
        removeChildAt(0)
      bitmap = new Bitmap()
      bitmap.smoothing = true
      addChild(bitmap)
    }
  }
}
