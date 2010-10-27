import flash.system.Capabilities
import mx.events.FlexEvent

protected function onInitialize(event:FlexEvent):void {
  if (/^Windows/.test(Capabilities.os))
    title = 'Settings'
  else
    title = 'Preferences'
}

