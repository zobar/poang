package dpk {
  import flash.desktop.NativeApplication
  import flash.display.DisplayObjectContainer
  import flash.display.NativeMenu
  import flash.display.NativeMenuItem
  import flash.system.Capabilities
  import mx.collections.ArrayCollection
  import mx.collections.IList
  import mx.controls.FlexNativeMenu
  import mx.events.CollectionEvent
  import mx.events.CollectionEventKind
  import mx.events.PropertyChangeEvent
  import spark.components.WindowedApplication

  [DefaultProperty('items')]
  public class NativeMenu extends FlexNativeMenu {
    [Bindable] public function get items():* {
      return _items
    }
    public function set items(value:*):void {
      if (items != value) {
        if (items) {
          items.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
              onItemsCollectionChange)
        }
        if (value == null || value is IList)
          _items = value
        else if (value is Array)
          _items = new ArrayCollection(value)
        else
          _items = new ArrayCollection([value])
        if (items) {
          for (var i:int = 0; i < items.length; ++i)
            items.getItemAt(i).parent = this
          items.addEventListener(CollectionEvent.COLLECTION_CHANGE,
              onItemsCollectionChange)
        }
        invalidateProperties()
      }
    }
    protected var _items:IList

    override public function get nativeMenu():flash.display.NativeMenu {
      return _nativeMenu
    }
    protected var _nativeMenu:flash.display.NativeMenu

    protected static function
        getNamedMenuItems(nativeMenu:flash.display.NativeMenu,
        applicationName:String=null, into:Object=null):Object {
      if (!applicationName) {
        if (Capabilities.isDebugger)
          applicationName = 'adl'
        else {
          var descriptor:XML =
              NativeApplication.nativeApplication.applicationDescriptor
          var xmlns:Namespace = descriptor.namespace()
          applicationName = descriptor.xmlns::filename
        }
      }
      if (!into)
        into = {}
      for (var i:int = 0; i < nativeMenu.numItems; ++i) {
        var item:NativeMenuItem = nativeMenu.getItemAt(i)
        var name:String = item.name
        if (!name) {
          name = item.label
          if (name == applicationName)
            name = 'application'
          else {
            name = name.replace(new RegExp('\\s*' + applicationName + '\\s*',
                'g'), '')
          }
          name = name.toLowerCase()
          name = name.replace(/[…]/g, '').replace(/\s+/g, '_').
              replace(/^_+|_+$/g, '')
          if (name)
            item.name = name
        }
        if (name)
          into[name] = item
        if (item.submenu)
          getNamedMenuItems(item.submenu, applicationName, into)
      }
      return into
    }

    protected static function updateMenu(items:IList,
        nativeMenu:flash.display.NativeMenu,
        namedMenuItems:Object = null):void {
      var allowSeparator:Boolean = false
      var i:int
      var nativeMenuItems:Array = []
      if (!namedMenuItems)
        namedMenuItems = getNamedMenuItems(nativeMenu)
      for (i = 0; i < items.length; ++i) {
        var group:MenuBase = MenuBase(items.getItemAt(i))
        for each (var menu:MenuItemBase in group.menuItems) {
          var isSeparator:Boolean = menu.isSeparator
          var nativeMenuItem:NativeMenuItem = menu.nativeMenuItem
          if (!nativeMenuItem) {
            var name:String = menu.name
            nativeMenuItem = namedMenuItems[name]
            if (nativeMenuItem)
              delete namedMenuItems[name]
          }
          if (!nativeMenuItem &&
              (menu.label || isSeparator) &&
              (!menu.osMatch || new RegExp(menu.osMatch).test(Capabilities.os)))
            nativeMenuItem = new NativeMenuItem(menu.label, isSeparator)
          if (nativeMenuItem) {
            menu.nativeMenuItem = nativeMenuItem
            if (nativeMenuItem.menu && nativeMenuItem.menu != nativeMenu)
              nativeMenuItem.menu.removeItem(nativeMenuItem)
            if (menu.children) {
              if (!nativeMenuItem.submenu)
                nativeMenuItem.submenu = new flash.display.NativeMenu()
              updateMenu(menu.children, menu.nativeMenuItem.submenu,
                  namedMenuItems)
            }
            else if (nativeMenuItem.submenu)
              nativeMenuItem.submenu = null
            if (!isSeparator || allowSeparator) {
              allowSeparator = !isSeparator
              nativeMenuItems.push(nativeMenuItem)
            }
          }
        }
      }
      for (i = nativeMenuItems.length - 1; i >= 0; --i) {
        nativeMenuItem = nativeMenuItems[i]
        if (nativeMenuItem.isSeparator)
          nativeMenuItems.pop()
        else
          break
      }
      nativeMenu.items = nativeMenuItems
    }

    override public function set
        automationParent(value:DisplayObjectContainer):void {
      _nativeMenu = NativeApplication.nativeApplication.menu
      if (value != automationParent) {
        super.automationParent = value
        if (automationParent is spark.components.WindowedApplication &&
            NativeApplication.supportsMenu)
          _nativeMenu = NativeApplication.nativeApplication.menu
        else
          _nativeMenu = new flash.display.NativeMenu()
      }
    }

    override protected function commitProperties():void {
      super.commitProperties()
      updateMenu(items, nativeMenu)
    }

    protected function onItemsCollectionChange(event:CollectionEvent):void {
      var changeEvent:PropertyChangeEvent
      var i:int
      var item:*
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
      invalidateProperties()
    }
  }
}
