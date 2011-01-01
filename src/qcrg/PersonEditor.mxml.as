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

[Bindable] public var person:Person

protected function labelToPersonFunction(value:String):Object {
  person.name = value
  return person
}

protected function onImageChange(event:Event):void {
  person.image = ImageWell(event.currentTarget).bitmapData
}

protected function onNumberFieldEvent(event:Event):void {
  var numberField:TextInput = TextInput(event.currentTarget)
  person.number = numberField.text
  numberField.selectAll()
}

protected function onPersonComboBoxChange(event:IndexChangeEvent):void {
  var comboBox:ComboBox = ComboBox(event.currentTarget)
  if (!person.updated)
    library.removePerson(person)
  person = Person(comboBox.selectedItem)
  dispatchEvent(new Event(Event.CHANGE))
  comboBox.selectedItem = person
}
