package poang {
  import flash.display.DisplayObject
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.display.MovieClip
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.system.LoaderContext
  import flash.utils.ByteArray

  public class Media extends LibraryItem {
    public static function createMedia(file:File, library:Library,
        internal:Boolean=false):Media {
      var parts:Array = file.url.match(/\/([^\/]*)\.([^.]*)$/)
      var extension:String = parts[2]
      var name:String = parts[1]
      var result:Media
      switch (extension) {
        case 'gif':
        case 'jpeg':
        case 'jpg':
        case 'png':
        case 'swf':
        default:
          result = new Media()
      }
      result.internal = internal
      result.library = library
      result.name = decodeURIComponent(name)
      result.file = file
      return result
    }

    [Bindable]
    public function get content():DisplayObject {
      return getMedia('content')
    }
    public function set content(value:DisplayObject):void {
      setMedia('content', value)
    }

    protected function get file():File {
      return _file
    }
    protected function set file(value:File):void {
      if (file)
        file.removeEventListener(Event.COMPLETE, onFileComplete)
      _file = value
      if (file) {
        file.addEventListener(Event.COMPLETE, onFileComplete)
        file.load()
      }
    }
    protected var _file:File

    protected var internal:Boolean

    override internal function set library(value:Library):void {
      super.library = value
      library.addMedia(this)
    }

    [Bindable]
    public function get name():String {
      return getString('name', '')
    }
    public function set name(value:String):void {
      setString('name', value, '')
    }

    [Bindable]
    public function get show():Boolean {
      return _show
    }
    public function set show(value:Boolean):void {
      _show = value
      if (content is MovieClip) {
        var movieClip:MovieClip = MovieClip(content)
        if (show)
          movieClip.gotoAndPlay(1)
        else
          movieClip.gotoAndStop(movieClip.totalFrames)
      }
    }
    protected var _show:Boolean

    public function setContent(value:DisplayObject, data:ByteArray):void {
      setMedia('content', value, data, internal ? name : null)
    }

    protected function onFileComplete(event:Event):void {
      var loader:Loader = new Loader()
      var loaderContext:LoaderContext = new LoaderContext()
      loaderContext.allowCodeImport = true
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
          onLoaderComplete)
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
          onLoaderIOError)
      loader.loadBytes(file.data, loaderContext)
    }

    protected function onLoaderComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      setContent(loaderInfo.content, file.data)
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
    }

    protected function onLoaderIOError(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError)
    }
  }
}
