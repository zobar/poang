import dpk.WindowHelper
import flash.system.Capabilities
import mx.collections.ArrayCollection
import mx.collections.IList
import mx.events.FlexEvent
import spark.components.supportClasses.ListBase
import spark.components.supportClasses.ToggleButtonBase

protected var helper:WindowHelper

[Bindable]
public var preferences:Preferences

[Bindable]
public function get releaseTracks():IList {
  if (!_releaseTracks)
    _releaseTracks = new ArrayCollection(['development', 'stable', 'unstable'])
  return _releaseTracks
}
public function set releaseTracks(value:IList):void {
  if (releaseTracks != value)
    _releaseTracks = value
}
protected var _releaseTracks:IList

protected function onAutoUpdateButtonChange(event:Event):void {
  preferences.autoUpdate = ToggleButtonBase(event.currentTarget).selected
}

protected function onCloseButtonClick(event:MouseEvent):void {
  close()
}

protected function onInitialize(event:FlexEvent):void {
  preferences = QCRGScoreboard.app.preferences
  helper = new WindowHelper('preferences', this, preferences)
  if (/^Windows/.test(Capabilities.os))
    title = 'Settings'
  else
    title = 'Preferences'
}

protected function onReleaseTrackListChange(event:Event):void {
  preferences.releaseTrack = ListBase(event.currentTarget).selectedItem
}
