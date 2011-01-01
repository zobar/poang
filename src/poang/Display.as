package poang {
  import dpk.fit
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.DisplayObject
  import flash.display.PixelSnapping
  import flash.geom.Rectangle
  import mx.binding.utils.BindingUtils
  import mx.binding.utils.ChangeWatcher
  import mx.collections.ArrayCollection
  import mx.core.UIComponent

  public class Display extends UIComponent {
    protected var bitmap:Bitmap

    [Bindable]
    public function get bitmapData():BitmapData {
      return _bitmapData
    }
    public function set bitmapData(value:BitmapData):void {
      _bitmapData = value
      invalidateDisplayList()
    }
    protected var _bitmapData:BitmapData

    [Bindable]
    public function get group():DisplayGroup {
      return _group
    }
    public function set group(value:DisplayGroup):void {
      if (group) {
        var displays:ArrayCollection = group.displays
        var i:int = displays.getItemIndex(this)
        if (i != -1)
          displays.removeItemAt(i)
        if (watcher)
          watcher.unwatch()
      }
      _group = value
      if (group) {
        group.displays.addItem(this)
        if (!bitmap) {
          bitmap = new Bitmap(group.bitmapData, PixelSnapping.AUTO, true)
          addChild(bitmap)
        }
        watcher = BindingUtils.bindProperty(this, 'bitmapData', group,
            'bitmapData')
      }
      else {
        if (bitmap) {
          removeChild(bitmap)
          bitmap = null
        }
        watcher = null
      }
    }
    protected var _group:DisplayGroup

    protected var watcher:ChangeWatcher

    override public function invalidateSize():void {
      super.invalidateSize()
      invalidateDisplayList()
    }

    override protected function measure():void {
      if (group) {
        var content:DisplayObject = group.content
        super.measure()
        if (content) {
          var bounds:Rectangle = group.contentBounds
          measuredHeight = bounds.height
          measuredWidth = bounds.width
        }
      }
    }

    override protected function updateDisplayList(unscaledWidth:Number,
        unscaledHeight:Number):void {
      super.updateDisplayList(unscaledHeight, unscaledWidth)
      graphics.clear()
      graphics.beginFill(0x000000)
      graphics.drawRect(0, 0, unscaledWidth, unscaledHeight)
      graphics.endFill()
      if (bitmap && bitmapData) {
        bitmap.bitmapData = bitmapData
        bitmap.transform.matrix = fit(new Rectangle(0, 0, bitmapData.width,
            bitmapData.height), new Rectangle(0, 0, unscaledWidth,
            unscaledHeight))
      }
    }
  }
}
