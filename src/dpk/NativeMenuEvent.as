package dpk {
  import flash.events.Event

  public class NativeMenuEvent extends Event {
    public function get menuItem():MenuItemBase {
      return _menuItem
    }
    protected var _menuItem:MenuItemBase

    public function NativeMenuEvent(type:String, bubbles:Boolean=false,
        cancelable:Boolean=false, menuItem:MenuItemBase=null) {
      super(type, bubbles, cancelable)
      _menuItem = menuItem
    }
  }
}

