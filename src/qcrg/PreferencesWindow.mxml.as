import flash.system.Capabilities
import mx.collections.ArrayCollection
import mx.collections.IList
import mx.events.FlexEvent

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

protected function onInitialize(event:FlexEvent):void {
  if (/^Windows/.test(Capabilities.os))
    title = 'Settings'
  else
    title = 'Preferences'
}
