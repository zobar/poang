package dpk {
  import flash.display.NativeMenuItem
  import flash.events.Event
  import mx.collections.ArrayCollection
  import mx.collections.IList
  import mx.events.CollectionEvent
  import mx.events.CollectionEventKind
  import mx.events.PropertyChangeEvent

  [Event(name='displaying', type='flash.events.Event')]
  [Event(name='select', type='flash.events.Event')]
  public class MenuItemBase {
    [Bindable] public var osMatch:String
    [Bindable] public var parent:*

    [Bindable] public function get children():* {
      return _children
    }
    public function set children(value:*):void {
      if (children != value) {
        var m:NativeMenu
        if (children) {
          children.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
              onChildrenCollectionChange)
        }
        if (value == null || value is IList)
          _children = value
        else if (value is Array)
          _children = new ArrayCollection(value)
        else
          _children = new ArrayCollection([value])
        if (children) {
          children.addEventListener(CollectionEvent.COLLECTION_CHANGE,
              onChildrenCollectionChange)
        }
        m = menu
        if (m)
          m.invalidateProperties()
      }
    }
    protected var _children:IList

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

    public function get menu():NativeMenu {
      var result:* = this
      while (result.parent)
        result = result.parent
      return result is NativeMenu ? result : null
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

    protected function
        onChildrenCollectionChange(event:CollectionEvent):void {
      var changeEvent:PropertyChangeEvent
      var i:int
      var item:*
      var m:NativeMenu
      switch (event.kind) {
        case CollectionEventKind.ADD:
          for each (item in event.items)
            item.parent = this
          break
        case CollectionEventKind.REMOVE:
          for each (item in event.items)
            item.parent = null
          break
        case CollectionEventKind.REPLACE:
          for each (changeEvent in event.items) {
            changeEvent.oldValue.parent = null
            changeEvent.newValue.parent = this
          }
          break
        case CollectionEventKind.RESET:
          for (i = 0; i < event.currentTarget.length; ++i)
            event.currentTarget.getItemAt(i).parent = this
          break
      }
      m = menu
      if (m)
        m.invalidateProperties()
    }

    protected function onNativeMenuDisplaying(event:Event):void {
      dispatchEvent(event)
    }

    protected function onNativeMenuSelect(event:Event):void {
      dispatchEvent(event)
    }
  }
}
