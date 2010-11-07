package qcrg {
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.filesystem.FileMode
  import flash.filesystem.FileStream
  import flash.geom.Rectangle

  [Event(name='complete')]
  [Event(name='ioError', type='flash.events.IOErrorEvent')]
  public class Preferences extends EventDispatcher {
    [Bindable]
    public function get autoUpdate():Boolean {
      return getBoolean('autoUpdate', true)
    }
    public function set autoUpdate(value:Boolean):void {
      setBoolean('autoUpdate', value, true)
    }

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

    [Bindable]
    public function get mainWindow():Rectangle {
      return getRectangle('mainWindow')
    }
    public function set mainWindow(value:Rectangle):void {
      setRectangle('mainWindow', value)
    }

    [Bindable]
    public function get mainWindowMaximized():Boolean {
      return getBoolean('mainWindowMaximized', false)
    }
    public function set mainWindowMaximized(value:Boolean):void {
      return setBoolean('mainWindowMaximized', value, false)
    }

    [Bindable]
    public function get preferencesWindow():Rectangle {
      return getRectangle('preferencesWindow')
    }
    public function set preferencesWindow(value:Rectangle):void {
      setRectangle('preferencesWindow', value)
    }

    [Bindable]
    public function get preferencesWindowMaximized():Boolean {
      return getBoolean('preferencesWindowMaximized', false)
    }
    public function set preferencesWindowMaximized(value:Boolean):void {
      return setBoolean('preferencesWindowMaximized', value, false)
    }

    [Bindable]
    public function get releaseTrack():String {
      return getString('releaseTrack', 'stable')
    }
    public function set releaseTrack(value:String):void {
      setString('releaseTrack', value, 'stable')
    }

    protected var xml:XML

    public function Preferences() {
      file = File.applicationStorageDirectory.resolvePath('preferences.xml')
      if (file.exists)
        file.load()
      else {
        xml = <preferences/>
        dispatchEvent(new Event(Event.COMPLETE))
      }
      QCRGScoreboard.app.addEventListener(Event.CLOSE, onApplicationClose)
    }

    protected function hasValue(key:String):Boolean {
      return xml && xml.hasOwnProperty(key)
    }

    protected function onFileComplete(event:Event):void {
      xml = XML(File(event.currentTarget).data)
      dispatchEvent(event)
    }

    protected function onFileIOError(event:IOErrorEvent):void {
      dispatchEvent(event)
    }

    protected function getBoolean(key:String, defaultValue:Boolean):Boolean {
      if (hasValue(key))
        return xml[key].toString() == 'true'
      return defaultValue
    }

    protected function getRectangle(key:String):Rectangle {
      var result:Rectangle
      if (hasValue(key)) {
        var parts:Array = getString(key).split(/\s+/, 4)
        result = new Rectangle(parseFloat(parts[0]), parseFloat(parts[1]),
            parseFloat(parts[2]), parseFloat(parts[3]))
      }
      return result
    }

    protected function getString(key:String, defaultValue:String=null):String {
      if (hasValue(key))
        return xml[key].toString()
      return defaultValue
    }

    protected function onApplicationClose(event:Event):void {
      var stream:FileStream = new FileStream()
      QCRGScoreboard.app.removeEventListener(Event.CLOSE, onApplicationClose)
      trace(xml)
      stream.open(file, FileMode.WRITE)
      stream.writeUTFBytes(xml.toXMLString())
      stream.close()
    }

    protected function setBoolean(key:String, value:Boolean, defaultValue:Boolean):void {
      setString(key, value.toString(), defaultValue.toString())
    }

    protected function setRectangle(key:String, value:Rectangle):void {
      if (value) {
        setString(key, value.x + ' ' + value.y + ' ' + value.width + ' ' +
            value.height)
      }
      else
        setString(key, null)
    }

    protected function setString(key:String, value:String,
        defaultValue:String=null):void {
      if (value != getString(key, defaultValue)) {
        if (value == null || value == defaultValue)
          delete xml[key]
        else
          xml[key] = value
      }
    }
  }
}