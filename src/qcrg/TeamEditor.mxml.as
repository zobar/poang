[Bindable] public var team:Team

protected function onImageChange(event:Event):void {
  team.image = ImageWell(event.currentTarget).bitmapData
}

protected function onNameFieldEvent(event:Event):void {
  var nameField:TextInput = TextInput(event.currentTarget)
  team.name = nameField.text
  nameField.selectAll()
}
