package poang {
  import dpk.URLLoaderHelper
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.DisplayObject
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.net.URLRequest

  public class Ruleset extends Loadable implements IRuleset {
    protected static var formats:Object = {
      intermissionLength:   formatTime,
      jamLength:            formatTime,
      lineupLength:         formatTime,
      overtimeLineupLength: formatTime,
      periodLength:         formatTime,
      periods:              String,
      timeoutLength:        formatTime,
      timeouts:             String,
      timeoutsPer:          String
    }

    public static function get ruleNames():Array {
      var result:Array = []
      for (var ruleName:String in formats)
        result.push(ruleName)
      return result
    }

    [Bindable] public var intermissionLength:int
    [Bindable] public var jamLength:int
    [Bindable] public var lineupLength:int
    [Bindable] public var overtimeLineupLength:int
    [Bindable] public var periodLength:int
    [Bindable] public var periods:int
    [Bindable] public var timeoutLength:int
    [Bindable] public var timeouts:int
    [Bindable] public var timeoutsPer:String

    [Bindable]
    public var icon:BitmapData

    [Bindable]
    public var name:String

    override protected function set xml(value:XML):void {
      icon = null
      super.xml = value
      if (xml && xml.hasComplexContent()) {
        name = xml.@name
        for each (var ruleName:String in ruleNames)
          this[ruleName] = getXML(ruleName).@value
        if (xml && xml.hasOwnProperty('@icon')) {
          var loader:Loader = new Loader()
          var loaderInfo:LoaderInfo = loader.contentLoaderInfo
          loaderInfo.addEventListener(Event.COMPLETE, onIconLoaderComplete)
          loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
              onIconLoaderIOError)
          loader.load(new URLRequest(url.replace(/[^\/]*$/, xml.@icon)))
        }
      }
    }

    protected static function formatTime(value:int):String {
      return poang.formatTime(value, true)
    }

    public function getDescription(ruleName:String):String {
      var parts:Array = []
      var xml:XML = getXML(ruleName)
      if (xml.hasOwnProperty('@description'))
        parts.push(xml.@description)
      else
        parts.push(getStringValue(ruleName))
      if (xml.hasOwnProperty('@citation'))
        parts.push('(' + xml.@citation + ')')
      return parts.join(' ')
    }

    public function getStringValue(ruleName:String, value:*=null):String {
      return formats[ruleName](value === null ? this[ruleName] : value)
    }

    protected function getXML(ruleName:String):XML {
      return XML(xml.rule.(@name==ruleName))
    }

    protected function onIconLoaderComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var content:DisplayObject = loaderInfo.loader.content
      if (content is Bitmap)
        icon = Bitmap(content).bitmapData
      loaderInfo.removeEventListener(Event.COMPLETE, onIconLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIconLoaderIOError)
    }

    protected function onIconLoaderIOError(event:IOErrorEvent):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, onIconLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIconLoaderIOError)
    }
  }
}
