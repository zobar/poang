[Bindable] public var team:Team

protected function onNameFieldEvent(event:Event):void {
  var nameField:TextInput = TextInput(event.currentTarget)
  team.name = nameField.text
  nameField.selectAll()
}
