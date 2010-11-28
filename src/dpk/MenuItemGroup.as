package dpk {
  import flash.events.EventDispatcher

  [DefaultProperty('children')]
  public class MenuItemGroup extends MenuBase {
    override public function get menuItems():Array {
      var result:Array = []
      for (var i:int = 0; i < children.length; ++i) {
        for each (var item:MenuItemBase in children.getItemAt(i).menuItems)
          result.push(item)
      }
      return result
    }
  }
}
