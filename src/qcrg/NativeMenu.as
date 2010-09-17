package qcrg {
  import mx.controls.FlexNativeMenu
  import mx.events.FlexNativeMenuEvent

  [DefaultProperty('dataProvider')]
  public class NativeMenu extends FlexNativeMenu {
    public function NativeMenu() {
      addEventListener(FlexNativeMenuEvent.ITEM_CLICK, onItemClick)
    }

    protected function onItemClick(event:FlexNativeMenuEvent):void {
      var menuItem:* = event.item
      if (menuItem is MenuItem)
        menuItem.dispatchEvent(event)
    }
  }
}

