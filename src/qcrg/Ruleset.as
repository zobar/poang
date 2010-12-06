package qcrg {
  import dpk.URLLoaderHelper
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.DisplayObject
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.net.URLLoader
  import flash.net.URLRequest

  [Event(name='complete')]
  [Event(name='ioError', type='flash.events.IOErrorEvent')]
  public class Ruleset extends AbstractRuleset {
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

    [Bindable]
    public var icon:BitmapData

    [Bindable]
    public var name:String

    protected var url:String

    protected function get xml():XML {
      return _xml
    }
    protected function set xml(value:XML):void {
      icon = null
      _xml = value
      if (xml) {
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
    protected var _xml:XML

    protected static function formatTime(value:int):String {
      return qcrg.formatTime(value, true)
    }

    public function Ruleset(url:String) {
      this.url = url
      new URLLoaderHelper(url, onFileComplete)
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

    protected function onFileComplete(event:Event):void {
      var loader:URLLoader = URLLoader(event.currentTarget)
      xml = XML(loader.data)
      dispatchEvent(event)
    }

    protected function onFileIOError(event:IOErrorEvent):void {
      dispatchEvent(event)
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
