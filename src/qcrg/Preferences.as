package qcrg {
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.geom.Rectangle

  public class Preferences extends AbstractLibraryRuleset implements IRuleset {
    [Bindable]
    public function get autoUpdate():Boolean {
      return getBoolean('autoUpdate', true)
    }
    public function set autoUpdate(value:Boolean):void {
      setBoolean('autoUpdate', value, true)
    }

    [Bindable]
    public function get displayScreens():Array {
      return getIntArray('displayScreens')
    }
    public function set displayScreens(value:Array):void {
      setIntArray('displayScreens', value)
    }

    override internal function set library(value:Library):void {
      super.library = value
      library.preferences = this
    }

    [Bindable]
    public function get mainWindow():Rectangle {
      return getRectangle('mainWindow')
    }
    public function set mainWindow(value:Rectangle):void {
      setRectangle('mainWindow', value)
    }

    [Bindable]
    public function get mainWindowMaximized():Boolean {
      return getBoolean('mainWindowMaximized', false)
    }
    public function set mainWindowMaximized(value:Boolean):void {
      return setBoolean('mainWindowMaximized', value, false)
    }

    [Bindable]
    public function get preferencesWindow():Rectangle {
      return getRectangle('preferencesWindow')
    }
    public function set preferencesWindow(value:Rectangle):void {
      setRectangle('preferencesWindow', value)
    }

    [Bindable]
    public function get preferencesWindowMaximized():Boolean {
      return getBoolean('preferencesWindowMaximized', false)
    }
    public function set preferencesWindowMaximized(value:Boolean):void {
      return setBoolean('preferencesWindowMaximized', value, false)
    }

    [Bindable]
    public function get propertiesWindow():Rectangle {
      return getRectangle('propertiesWindow')
    }
    public function set propertiesWindow(value:Rectangle):void {
      setRectangle('propertiesWindow', value)
    }

    [Bindable]
    public function get propertiesWindowMaximized():Boolean {
      return getBoolean('propertiesWindowMaximized', false)
    }
    public function set propertiesWindowMaximized(value:Boolean):void {
      return setBoolean('propertiesWindowMaximized', value, false)
    }

    [Bindable]
    public function get releaseTrack():String {
      return getString('releaseTrack', 'stable')
    }
    public function set releaseTrack(value:String):void {
      setString('releaseTrack', value, 'stable')
    }

    [Bindable]
    public function get updateCompleteWindow():Rectangle {
      return getRectangle('updateCompleteWindow')
    }
    public function set updateCompleteWindow(value:Rectangle):void {
      setRectangle('updateCompleteWindow', value)
    }

    [Bindable]
    public function get updateCompleteWindowMaximized():Boolean {
      return getBoolean('updateCompleteWindowMaximized', false)
    }
    public function set updateCompleteWindowMaximized(value:Boolean):void {
      return setBoolean('updateCompleteWindowMaximized', value, false)
    }

    [Bindable]
    public function get updateNotificationWindow():Rectangle {
      return getRectangle('updateNotificationWindow')
    }
    public function set updateNotificationWindow(value:Rectangle):void {
      setRectangle('updateNotificationWindow', value)
    }

    [Bindable]
    public function get updateNotificationWindowMaximized():Boolean {
      return getBoolean('updateNotificationWindowMaximized', false)
    }
    public function set updateNotificationWindowMaximized(value:Boolean):void {
      return setBoolean('updateNotificationWindowMaximized', value, false)
    }

    override public function set xml(value:XML):void {
      var r:Ruleset = new Ruleset()
      ruleset = r
      load(r, File.applicationDirectory.resolvePath('ruleset.xml').url)
      super.xml = value
    }
  }
}
