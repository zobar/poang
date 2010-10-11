package dpk {
  import flash.display.NativeMenuItem
  import flash.events.Event

  [Event(name='displaying', type='flash.events.Event')]
  [Event(name='select', type='flash.events.Event')]
  public class MenuItemBase {
    [Bindable] public var children:Array
    [Bindable] public var osMatch:String

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
              onNativeMenuDisplaying)
          nativeMenuItem.removeEventListener(Event.SELECT, onNativeMenuSelect)
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
          nativeMenuItem.addEventListener(Event.DISPLAYING,
              onNativeMenuDisplaying)
          nativeMenuItem.addEventListener(Event.SELECT, onNativeMenuSelect)
        }
      }
    }
    private var _nativeMenuItem:NativeMenuItem

    protected function onNativeMenuDisplaying(event:Event):void {
      dispatchEvent(event)
    }

    protected function onNativeMenuSelect(event:Event):void {
      dispatchEvent(event)
    }
  }
}
