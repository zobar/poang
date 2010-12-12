import dpk.WindowHelper
import mx.events.FlexEvent

[Bindable]
public var bout:Bout

protected var helper:WindowHelper

protected function onCloseButtonClick(event:MouseEvent):void {
  close()
}

protected function onInitialize(event:FlexEvent):void {
  helper = new WindowHelper('properties', this, QCRGScoreboard.app.preferences)
}

protected function onNameFieldEvent(event:Event):void {
  var nameField:TextInput = TextInput(event.currentTarget)
  bout.name = nameField.text
  nameField.selectAll()
}
