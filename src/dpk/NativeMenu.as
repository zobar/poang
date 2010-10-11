package dpk {
  import flash.desktop.NativeApplication
  import flash.display.DisplayObjectContainer
  import flash.display.NativeMenu
  import flash.display.NativeMenuItem
  import flash.system.Capabilities
  import mx.controls.FlexNativeMenu
  import spark.components.WindowedApplication

  [DefaultProperty('items')]
  public class NativeMenu extends FlexNativeMenu {
    [Bindable]
    public var items:Array

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
        updateMenu(items, nativeMenu)
      }
    }

    public function NativeMenu() {
    }

    protected function updateMenu(items:Array,
        nativeMenu:flash.display.NativeMenu,
        namedMenuItems:Object = null):void {
      var allowSeparator:Boolean = false
      var nativeMenuItems:Array = []
      if (!namedMenuItems)
        namedMenuItems = getNamedMenuItems(nativeMenu)
      for each (var menu:MenuItemBase in items) {
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
            updateMenu(menu.children, menu.nativeMenuItem.submenu, namedMenuItems)
          }
          else if (nativeMenuItem.submenu)
            nativeMenuItem.submenu = null
          if (!isSeparator || allowSeparator) {
            allowSeparator = !isSeparator
            nativeMenuItems.push(nativeMenuItem)
          }
        }
      }
      for (var i:int = nativeMenuItems.length - 1; i >= 0; --i) {
        nativeMenuItem = nativeMenuItems[i]
        if (nativeMenuItem.isSeparator)
          nativeMenuItems.pop()
        else
          break
      }
      nativeMenu.items = nativeMenuItems
    }
  }
}
