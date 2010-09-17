package qcrg {
  import flash.system.Capabilities
  import mx.events.FlexNativeMenuEvent

  [Event(name='itemClick', type='mx.events.FlexNativeMenuEvent')]
  public class MenuItem {
    [Bindable] public function get controlKey():Boolean {
      return _controlKey
    }
    public function set controlKey(value:Boolean):void {
      if (/^Mac OS/.test(Capabilities.os))
        commandKey = value
      else
        _controlKey = value
    }
    protected var _controlKey:Boolean

    [Bindable] public var commandKey:Boolean
    [Bindable] public var keyEquivalent:String
    [Bindable] public var label:String
    [Bindable] public var toggled:Boolean
    [Bindable] public var type:String
  }
}
