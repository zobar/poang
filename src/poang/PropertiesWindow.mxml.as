import dpk.WindowHelper
import mx.events.FlexEvent

[Bindable]
public var bout:Bout

protected var helper:WindowHelper

protected function onCloseButtonClick(event:MouseEvent):void {
  close()
}

protected function onInitialize(event:FlexEvent):void {
  helper = new WindowHelper('properties', this, Poang.app.preferences)
}

protected function onNameFieldEvent(event:Event):void {
  var nameField:TextInput = TextInput(event.currentTarget)
  bout.name = nameField.text
  nameField.selectAll()
}

protected function onHomeTeamChange(event:Event):void {
  bout.homeTeam = TeamEditor(event.currentTarget).team
}

protected function onVisitorTeamChange(event:Event):void {
  bout.visitorTeam = TeamEditor(event.currentTarget).team
}

