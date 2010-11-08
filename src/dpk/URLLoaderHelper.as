package dpk {
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.net.URLLoader
  import flash.net.URLRequest

  public class URLLoaderHelper {
    protected var completeHandler:Function
    protected var ioErrorHandler:Function

    public function URLLoaderHelper(url:String, completeHandler:Function,
        ioErrorHandler:Function=null) {
      var loader:URLLoader = new URLLoader()
      this.completeHandler = completeHandler
      this.ioErrorHandler = ioErrorHandler
      loader.addEventListener(Event.COMPLETE, onComplete)
      loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError)
      loader.load(new URLRequest(url))
    }

    protected function removeEventListeners(event:Event):void {
      var loader:URLLoader = URLLoader(event.currentTarget)
      loader.removeEventListener(Event.COMPLETE, onComplete)
      loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError)
    }

    protected function onComplete(event:Event):void {
      removeEventListeners(event)
      completeHandler(event)
    }

    protected function onIOError(event:IOErrorEvent):void {
      removeEventListeners(event)
      if (ioErrorHandler != null)
        ioErrorHandler(event)
    }
  }
}
