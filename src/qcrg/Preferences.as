package qcrg {
  import dpk.minutes
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.filesystem.FileMode
  import flash.filesystem.FileStream
  import flash.geom.Rectangle

  [Event(name='complete')]
  [Event(name='ioError', type='flash.events.IOErrorEvent')]
  public class Preferences extends EventDispatcher implements IRuleset {
    [Bindable]
    public function get autoUpdate():Boolean {
      return getBoolean('autoUpdate', true)
    }
    public function set autoUpdate(value:Boolean):void {
      setBoolean('autoUpdate', value, true)
    }

    public function get complete():Boolean {
      return xml != null
    }

    [Bindable]
    public function get displayScreens():Array {
      return getIntArray('displayScreens')
    }
    public function set displayScreens(value:Array):void {
      setIntArray('displayScreens', value)
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
    public function get intermissionLength():int {
      return getInt('intermissionLength', ruleset.intermissionLength)
    }
    public function set intermissionLength(value:int):void {
      setInt('intermissionLength', value, ruleset.intermissionLength)
    }

    [Bindable]
    public function get jamLength():int {
      return getInt('jamLength', ruleset.jamLength)
    }
    public function set jamLength(value:int):void {
      setInt('jamLength', value, ruleset.jamLength)
    }

    [Bindable]
    public function get lineupLength():int {
      return getInt('lineupLength', ruleset.lineupLength)
    }
    public function set lineupLength(value:int):void {
      setInt('lineupLength', value, ruleset.lineupLength)
    }

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
    public function get overtimeLineupLength():int {
      return getInt('overtimeLineupLength', ruleset.overtimeLineupLength)
    }
    public function set overtimeLineupLength(value:int):void {
      setInt('overtimeLineupLength', value, ruleset.overtimeLineupLength)
    }

    [Bindable]
    public function get periodLength():int {
      return getInt('periodLength', ruleset.periodLength)
    }
    public function set periodLength(value:int):void {
      setInt('periodLength', value, ruleset.periodLength)
    }

    [Bindable]
    public function get periods():int {
      return getInt('periods', ruleset.periods)
    }
    public function set periods(value:int):void {
      setInt('periods', value, ruleset.periods)
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
    public function get propertiesWindow():Rectangle {
      return getRectangle('propertiesWindow')
    }
    public function set propertiesWindow(value:Rectangle):void {
      setRectangle('propertiesWindow', value)
    }

    [Bindable]
    public function get propertiesWindowMaximized():Boolean {
      return getBoolean('propertiesWindowMaximized', false)
    }
    public function set propertiesWindowMaximized(value:Boolean):void {
      return setBoolean('propertiesWindowMaximized', value, false)
    }

    [Bindable]
    public function get releaseTrack():String {
      return getString('releaseTrack', 'stable')
    }
    public function set releaseTrack(value:String):void {
      setString('releaseTrack', value, 'stable')
    }

    [Bindable]
    public var ruleset:Ruleset

    [Bindable]
    public function get timeoutLength():int {
      return getInt('timeoutLength', ruleset.timeoutLength)
    }
    public function set timeoutLength(value:int):void {
      setInt('timeoutLength', value, ruleset.timeoutLength)
    }

    [Bindable]
    public function get timeouts():int {
      return getInt('timeouts', ruleset.timeouts)
    }
    public function set timeouts(value:int):void {
      setInt('timeouts', value, ruleset.timeouts)
    }

    [Bindable]
    public function get timeoutsPer():String {
      return getString('timeoutsPer', ruleset.timeoutsPer)
    }
    public function set timeoutsPer(value:String):void {
      setString('timeoutsPer', value, ruleset.timeoutsPer)
    }

    [Bindable]
    public function get updateCompleteWindow():Rectangle {
      return getRectangle('updateCompleteWindow')
    }
    public function set updateCompleteWindow(value:Rectangle):void {
      setRectangle('updateCompleteWindow', value)
    }

    [Bindable]
    public function get updateCompleteWindowMaximized():Boolean {
      return getBoolean('updateCompleteWindowMaximized', false)
    }
    public function set updateCompleteWindowMaximized(value:Boolean):void {
      return setBoolean('updateCompleteWindowMaximized', value, false)
    }

    [Bindable]
    public function get updateNotificationWindow():Rectangle {
      return getRectangle('updateNotificationWindow')
    }
    public function set updateNotificationWindow(value:Rectangle):void {
      setRectangle('updateNotificationWindow', value)
    }

    [Bindable]
    public function get updateNotificationWindowMaximized():Boolean {
      return getBoolean('updateNotificationWindowMaximized', false)
    }
    public function set updateNotificationWindowMaximized(value:Boolean):void {
      return setBoolean('updateNotificationWindowMaximized', value, false)
    }

    protected var xml:XML

    public function Preferences() {
      ruleset =
          new Ruleset(File.applicationDirectory.resolvePath('ruleset.xml').url)
      ruleset.addEventListener(Event.COMPLETE, onRulesetComplete)
      ruleset.addEventListener(IOErrorEvent.IO_ERROR, onRulesetIOError)
      file = File.applicationStorageDirectory.resolvePath('preferences.xml')
      if (file.exists)
        file.load()
      else {
        xml = <preferences/>
        if (ruleset.complete)
          dispatchEvent(new Event(Event.COMPLETE))
      }
      QCRGScoreboard.app.addEventListener(Event.CLOSE, onApplicationClose)
    }

    protected function getBoolean(key:String, defaultValue:Boolean):Boolean {
      if (hasValue(key))
        return xml[key].toString() == 'true'
      return defaultValue
    }

    protected function getInt(key:String, defaultValue:int):int {
      if (hasValue(key))
        return parseInt(xml[key])
      return defaultValue
    }

    protected function getIntArray(key:String):Array {
      var result:Array
      if (hasValue(key)) {
        var parts:Array = getString(key).split(/\s+/)
        result = []
        for each (var part:String in parts)
          result.push(parseInt(part))
      }
      return result
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

    protected function hasValue(key:String):Boolean {
      return xml && xml.hasOwnProperty(key)
    }

    protected function onApplicationClose(event:Event):void {
      var stream:FileStream = new FileStream()
      QCRGScoreboard.app.removeEventListener(Event.CLOSE, onApplicationClose)
      trace(xml)
      stream.open(file, FileMode.WRITE)
      stream.writeUTFBytes(xml.toXMLString())
      stream.close()
    }

    protected function onFileComplete(event:Event):void {
      xml = XML(File(event.currentTarget).data)
      if (ruleset.complete)
        dispatchEvent(event)
    }

    protected function onFileIOError(event:IOErrorEvent):void {
      dispatchEvent(event)
    }

    protected function onRulesetComplete(event:Event):void {
      if (complete)
        dispatchEvent(event)
    }

    protected function onRulesetIOError(event:IOErrorEvent):void {
      dispatchEvent(event)
    }

    protected function setBoolean(key:String, value:Boolean,
        defaultValue:Boolean):void {
      setString(key, value.toString(), defaultValue.toString())
    }

    protected function setInt(key:String, value:int, defaultValue:int):void {
      setString(key, value.toString(), defaultValue.toString())
    }

    protected function setIntArray(key:String, value:Array):void {
      if (value)
        setString(key, value.join(' '))
      else
        setString(key, null)
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
