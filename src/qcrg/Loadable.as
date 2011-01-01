package qcrg {
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.utils.getQualifiedClassName

  [Event(name='complete')]
  [Event(name='ioError', type='flash.events.IOErrorEvent')]
  public class Loadable extends EventDispatcher {
    protected function get file():File {
      return _file
    }
    protected function set file(value:File):void {
      if (file != value) {
        if (file) {
          file.removeEventListener(Event.COMPLETE, onFileComplete)
          file.removeEventListener(IOErrorEvent.IO_ERROR, onFileIOError)
        }
        _file = value
        if (file) {
          file.addEventListener(Event.COMPLETE, onFileComplete)
          file.addEventListener(IOErrorEvent.IO_ERROR, onFileIOError)
        }
      }
    }
    protected var _file:File

    public function get url():String {
      return _url
    }
    protected var _url:String

    protected function get xml():XML {
      return _xml
    }
    protected function set xml(value:XML):void {
      _xml = value
    }
    protected var _xml:XML

    public function Loadable() {
      _url = url
      xml = <{getQualifiedClassName(this).match(/[^:]*$/)[0].toLowerCase()}/>
    }

    public function load(url:String):void {
      _url = url
      file = new File(url)
      if (file && file.exists)
        file.load()
      else
        dispatchEvent(new Event(Event.COMPLETE))
    }

    protected function onFileComplete(event:Event):void {
      xml = XML(File(event.currentTarget).data)
      dispatchEvent(event)
    }

    protected function onFileIOError(event:IOErrorEvent):void {
      dispatchEvent(event)
    }
  }
}
