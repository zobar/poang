package dpk {
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.DisplayObject
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.events.KeyboardEvent
  import flash.events.MouseEvent
  import flash.filesystem.File
  import flash.net.FileFilter
  import flash.net.URLRequest
  import flash.ui.Keyboard
  import flash.utils.ByteArray
  import mx.managers.IFocusManagerComponent
  import spark.components.supportClasses.SkinnableComponent

  [Event(name='change')]
  [Style(name='backgroundImage')]
  [Style(name='backgroundImageFillMode', enumeration='clip,repeat,scale',
      type='String')]
  public class ImageWell extends SkinnableComponent
      implements IFocusManagerComponent {
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

    [Bindable]
    public var data:ByteArray

    protected function get file():File {
      if (!_file)
        file = new File()
      return _file
    }
    protected function set file(value:File):void {
      if (_file) {
        _file.removeEventListener(Event.COMPLETE, onFileComplete)
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onFileIOError)
        _file.removeEventListener(Event.SELECT, onFileSelect)
      }
      _file = value
      if (_file) {
        _file.addEventListener(Event.COMPLETE, onFileComplete)
        _file.addEventListener(IOErrorEvent.IO_ERROR, onFileIOError)
        _file.addEventListener(Event.SELECT, onFileSelect)
      }
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
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
      addEventListener(MouseEvent.CLICK, onClick)
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick)
    }

    public function open():void {
      file.browseForOpen(title, [new FileFilter('Images', '*.gif;*.jpg;*.png')])
    }

    protected function onClick(event:MouseEvent):void {
      focusManager.setFocus(this)
      focusManager.showFocus()
    }

    protected function onDoubleClick(event:MouseEvent):void {
      open()
    }

    protected function onFileComplete(event:Event):void {
      var loader:Loader = new Loader()
      data = file.data
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
          onLoaderComplete)
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
          onLoaderIOError)
      loader.loadBytes(data)
    }

    protected function onFileIOError(event:Event):void {
      bitmapData = null
      data = null
      dispatchEvent(new Event(Event.CHANGE))
    }

    protected function onFileSelect(event:Event):void {
      file.load()
    }

    protected function onKeyDown(event:KeyboardEvent):void {
      switch (event.keyCode) {
        case Keyboard.BACKSPACE:
        case Keyboard.DELETE:
          bitmapData = null
          data = null
          dispatchEvent(new Event(Event.CHANGE))
          break
        case Keyboard.ENTER:
          open()
          break
      }
    }

    protected function onLoaderComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
      var content:DisplayObject = loaderInfo.content
      if (content is Bitmap)
        bitmapData = Bitmap(content).bitmapData
      else {
        bitmapData = null
        data = null
      }
      dispatchEvent(new Event(Event.CHANGE))
    }

    protected function onLoaderIOError(event:IOErrorEvent):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
      bitmapData = null
      data = null
      dispatchEvent(new Event(Event.CHANGE))
    }

    override public function validateProperties():void {
      super.validateProperties()
      skin['imageDisplay'].bitmapData = bitmapData
    }
  }
}
