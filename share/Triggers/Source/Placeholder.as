package {
  import flash.display.Bitmap
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.display.Sprite
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.geom.Rectangle
  import flash.geom.Matrix
  import flash.net.URLRequest

  public class Placeholder extends Sprite {
    protected var aspectRatio:Number
    protected var bounds:Rectangle
    protected var loader:Loader

    public function get source():String {
      return _source
    }
    public function set source(value:String):void {
      if (value != source) {
        _source = value
        if (source) {
          var newLoader:Loader = new Loader()
          newLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete)
          newLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
          newLoader.load(new URLRequest(source))
        }
        else if (loader) {
          removeChild(loader)
          loader = null
        }
      }
    }
    protected var _source:String

    public function Placeholder() {
      bounds = getBounds(this)
      aspectRatio = bounds.width / bounds.height
      graphics.clear()
      while (numChildren)
        removeChildAt(0)
    }

    protected function onLoaderComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var matrix:Matrix = new Matrix()
      var scale:Number
      var sourceHeight:Number = loaderInfo.height
      var sourceWidth:Number = loaderInfo.width
      var tx:Number = bounds.x
      var ty:Number = bounds.y
      var sourceAspectRatio:Number = sourceWidth / sourceHeight
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
      if (sourceAspectRatio >= aspectRatio) {
        scale = bounds.width / sourceWidth
        ty += (bounds.height - (sourceHeight * scale)) / 2
      }
      else {
        scale = bounds.height / sourceHeight
        tx += (bounds.width - (sourceWidth * scale)) / 2
      }
      matrix.scale(scale, scale)
      matrix.translate(tx, ty)
      if (loader)
        removeChild(loader)
      loader = loaderInfo.loader
      loader.transform.matrix = matrix
      if (loader.content is Bitmap)
        Bitmap(loader.content).smoothing = true
      addChild(loader)
    }

    protected function onLoaderIOError(event:IOErrorEvent):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
      if (loader) {
        removeChild(loader)
        loader = null
      }
    }
  }
}
