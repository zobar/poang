package dpk {
  import flash.display.NativeMenuItem
  import flash.events.Event

  public class MenuItemBase extends MenuBase {
    [Bindable]
    public var data:*

    public function get isSeparator():Boolean {
      return false
    }

    [Bindable]
    public function get label():String {
      return _label
    }
    public function set label(value:String):void {
      if (label != value) {
        _label = value
        if (nativeMenuItem)
          nativeMenuItem.label = label
      }
    }
    protected var _label:String

    override public function get menuItems():Array {
      return [this]
    }

    [Bindable]
    public function get name():String {
      return _name
    }
    public function set name(value:String):void {
      if (name != value) {
        _name = value
        if (nativeMenuItem)
          nativeMenuItem.name = name
      }
    }
    protected var _name:String

    [Bindable]
    public function get nativeMenuItem():NativeMenuItem {
      return _nativeMenuItem
    }
    public function set nativeMenuItem(value:NativeMenuItem):void {
      if (nativeMenuItem != value) {
        if (nativeMenuItem) {
          nativeMenuItem.removeEventListener(Event.DISPLAYING,
              onNativeMenuEvent)
          nativeMenuItem.removeEventListener(Event.SELECT, onNativeMenuEvent)
          nativeMenuItem.data = null
        }
        _nativeMenuItem = value
        if (nativeMenuItem) {
          if (nativeMenuItem.data is MenuItem)
            MenuItem(nativeMenuItem.data).nativeMenuItem = null
          nativeMenuItem.data = this
          if (label)
            nativeMenuItem.label = label
          nativeMenuItem.name = name
          nativeMenuItem.addEventListener(Event.DISPLAYING, onNativeMenuEvent)
          nativeMenuItem.addEventListener(Event.SELECT, onNativeMenuEvent)
        }
      }
    }
    private var _nativeMenuItem:NativeMenuItem

    protected function onNativeMenuEvent(event:Event):void {
      var e:Event = new NativeMenuEvent(event.type, false, false, this)
      var here:* = this
      while (here) {
        here.dispatchEvent(e)
        here = 'parent' in here ? here.parent : null
      }
    }
  }
}
