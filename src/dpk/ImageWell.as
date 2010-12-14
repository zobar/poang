package dpk {
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.DisplayObject
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.events.MouseEvent
  import flash.filesystem.File
  import flash.net.FileFilter
  import flash.net.URLRequest
  import spark.components.supportClasses.SkinnableComponent

  [Event(name='change')]
  [Style(name='backgroundImage')]
  [Style(name='backgroundImageFillMode', enumeration='clip,repeat,scale',
      type='String')]
  public class ImageWell extends SkinnableComponent {
    [Bindable]
    public function get bitmapData():BitmapData {
      return _bitmapData
    }
    public function set bitmapData(value:BitmapData):void {
      if (bitmapData != value) {
        _bitmapData = value
        invalidateProperties()
      }
    }
    protected var _bitmapData:BitmapData

    protected function get file():File {
      if (!_file)
        file = new File()
      return _file
    }
    protected function set file(value:File):void {
      if (_file)
        _file.removeEventListener(Event.SELECT, onFileSelect)
      _file = value
      if (_file)
        _file.addEventListener(Event.SELECT, onFileSelect)
    }
    protected var _file:File

    [Bindable]
    public function get title():String {
      if (!_title)
        _title = 'Open Image'
      return _title
    }
    public function set title(value:String):void {
      _title = value
    }
    protected var _title:String

    public function ImageWell() {
      doubleClickEnabled = true
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick)
    }

    protected function onDoubleClick(event:MouseEvent):void {
      file.browseForOpen(title, [new FileFilter('Images', '*.gif;*.jpg;*.png')])
    }

    protected function onFileSelect(event:Event):void {
      var loader:Loader = new Loader()
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
          onLoaderComplete)
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
          onLoaderIOError)
      loader.load(new URLRequest(file.url))
    }

    protected function onLoaderComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var content:DisplayObject = loaderInfo.loader.content
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
      if (content is Bitmap)
        bitmapData = Bitmap(content).bitmapData
      else
        bitmapData = null
      dispatchEvent(new Event(Event.CHANGE))
    }

    protected function onLoaderIOError(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var content:DisplayObject = loaderInfo.loader.content
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
      bitmapData = null
      dispatchEvent(new Event(Event.CHANGE))
    }

    override public function validateProperties():void {
      super.validateProperties()
      skin['imageDisplay'].bitmapData = bitmapData
    }
  }
}
