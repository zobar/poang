import spark.events.IndexChangeEvent

[Bindable]
public function get library():Library {
  if (!_library)
    _library = QCRGScoreboard.app.library
  return _library
}
public function set library(value:Library):void {
  _library = value
}
protected var _library:Library

[Bindable(event='change')]
public function get team():Team {
  return _team
}
public function set team(value:Team):void {
  if (team != value) {
    _team = value
    dispatchEvent(new Event(Event.CHANGE))
  }
}
protected var _team:Team

protected function labelToTeamFunction(value:String):Object {
  team.name = value
  return team
}

protected function onAddButtonClick(event:MouseEvent):void {
  var person:Person = new Person()
  team.people.addItem(person)
  personList.selectedItem = person
  personEditor.personComboBox.setFocus()
}

protected function onImageChange(event:Event):void {
  var imageWell:ImageWell = ImageWell(event.currentTarget)
  team.setImage(imageWell.bitmapData, imageWell.data)
}

protected function onPersonEditorChange(event:Event):void {
  team.people.setItemAt(personEditor.person, personList.selectedIndex)
}

protected function onRemoveButtonClick(event:MouseEvent):void {
  team.people.removeItemAt(personList.selectedIndex)
}

protected function onTeamComboBoxChange(event:IndexChangeEvent):void {
  team = ComboBox(event.currentTarget).selectedItem
}
