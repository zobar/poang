package dpk {
  import flash.events.EventDispatcher
  import mx.collections.ArrayCollection
  import mx.collections.IList
  import mx.events.CollectionEvent
  import mx.events.CollectionEventKind
  import mx.events.PropertyChangeEvent

  [Event(name='displaying', type='dpk.NativeMenuEvent')]
  [Event(name='select', type='dpk.NativeMenuEvent')]
  public class MenuBase extends EventDispatcher {
    [Bindable] public var menuItemFunction:Function
    [Bindable] public var osMatch:String
    [Bindable] public var parent:*

    [Bindable]
    public function get children():* {
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
          for (var i:int = 0; i < children.length; ++i)
            children.getItemAt(i).parent = this
        }
        m = menu
        if (m)
          m.invalidateProperties()
      }
    }
    protected var _children:IList

    [Bindable]
    public function get dataProvider():* {
      return _dataProvider
    }
    public function set dataProvider(value:*):void {
      if (dataProvider != value) {
        var m:NativeMenu
        if (dataProvider) {
          dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
            onDataProviderCollectionChange)
        }
        if (value == null || value is IList)
          _dataProvider = value
        else if (value is Array)
          _dataProvider = new ArrayCollection(value)
        else
          _dataProvider = new ArrayCollection([value])
        if (dataProvider) {
          dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,
            onDataProviderCollectionChange)
        }
        children = []
        updateChildren()
        m = menu
        if (m)
          m.invalidateProperties()
      }
    }
    protected var _dataProvider:IList

    public function get menu():NativeMenu {
      var result:* = this
      while ('parent' in result && result.parent)
        result = result.parent
      return result is NativeMenu ? result : null
    }

    public function get menuItems():Array {
      return []
    }

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

    protected function
        onDataProviderCollectionChange(event:CollectionEvent):void {
      var changeEvent:PropertyChangeEvent
      var i:int = event.location
      var item:*
      var m:NativeMenu
      var menuItem:MenuItemBase
      switch (event.kind) {
        case CollectionEventKind.ADD:
          for each (item in event.items)
            children.addItemAt(menuItemFunction(item, null), i++)
          break
        case CollectionEventKind.REFRESH:
        case CollectionEventKind.RESET:
          updateChildren()
          break
        case CollectionEventKind.REMOVE:
          for each (item in event.items)
            children.removeItemAt(i++)
          break
        case CollectionEventKind.REPLACE:
          for each (changeEvent in event.items) {
            children.setItemAt(menuItemFunction(changeEvent.newValue,
                children.getItemAt(i)), i)
            ++i
          }
          break
        case CollectionEventKind.UPDATE:
          for each (changeEvent in event.items) {
            children.setItemAt(menuItemFunction(changeEvent.source,
                children.getItemAt(i)), i)
            ++i
          }
          break
      }
      m = menu
      if (m)
        m.invalidateProperties()
    }

    protected function updateChildren():void {
      var i:int
      for (i = 0; i < dataProvider.length; ++i) {
        var adding:Boolean = i >= children.length
        var menuItem:MenuItemBase = menuItemFunction(dataProvider.getItemAt(i),
            adding ? null : children.getItemAt(i))
        if (adding)
          children.addItem(menuItem)
        else
          children.setItemAt(menuItem, i)
      }
      while (i >= children.length)
        children.removeItemAt(i)
    }
  }
}
