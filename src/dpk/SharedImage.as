package dpk {
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.geom.Rectangle
  import mx.core.UIComponent

  public class SharedImage extends UIComponent {
    protected var bitmap:Bitmap

    [Bindable]
    public function get bitmapData():BitmapData {
      return _bitmapData
    }
    public function set bitmapData(value:BitmapData):void {
      _bitmapData = value
      invalidateDisplayList()
      invalidateProperties()
      invalidateSize()
    }
    protected var _bitmapData:BitmapData

    override public function validateProperties():void {
      super.validateProperties()
      bitmap.bitmapData = bitmapData
    }

    override protected function createChildren():void {
      super.createChildren()
      bitmap = new Bitmap()
      bitmap.smoothing = true
      addChild(bitmap)
    }

    override protected function measure():void {
      super.measure()
      if (bitmapData) {
        measuredHeight = bitmapData.height
        measuredWidth = bitmapData.width
      }
    }

    override protected function updateDisplayList(unscaledWidth:Number,
        unscaledHeight:Number):void {
      super.updateDisplayList(unscaledWidth, unscaledHeight)
      if (bitmapData) {
        bitmap.transform.matrix = fit(new Rectangle(0, 0, bitmapData.width,
            bitmapData.height), new Rectangle(0, 0, unscaledWidth,
            unscaledHeight))
      }
    }
  }
}
