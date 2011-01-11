import dpk.CheckBoxListItemRenderer
import flash.display.LoaderInfo
import flash.events.Event
import flash.events.FileListEvent
import flash.filesystem.File
import flash.geom.Rectangle
import mx.collections.ArrayCollection
import mx.events.DataGridEvent

protected function get file():File {
  return _file
}
protected function set file(value:File):void {
  if (file) {
    file.removeEventListener(FileListEvent.SELECT_MULTIPLE,
        onFileSelectMultiple)
  }
  _file = value
  if (file)
    file.addEventListener(FileListEvent.SELECT_MULTIPLE, onFileSelectMultiple)
}
protected var _file:File

[Bindable] public var media:ArrayCollection

[Bindable]
public function get selectedMedia():Media {
  return _selectedMedia
}
public function set selectedMedia(value:Media):void {
  if (!value && media.length)
    value = Media(media.getItemAt(0))
  if (value != selectedMedia) {
    if (selectedMedia)
      selectedMedia.show = false
    _selectedMedia = value
    if (selectedMedia)
      selectedMedia.show = true
  }
}
protected var _selectedMedia:Media

protected function onAddMediaClick(event:MouseEvent):void {
  if (!file)
    file = new File()
  file.browseForOpenMultiple('Open Media',
      [new FileFilter('Media', '*.gif;*.jpeg;*.jpg;*.png;*.swf')])
}

protected function onMediaItemEditBeginning(event:DataGridEvent):void {
  var dataGrid:DataGrid = DataGrid(event.currentTarget)
  var column:DataGridColumn = dataGrid.columns[event.columnIndex]
  if (column == showColumn) {
    var app:Poang = Poang.app
    var checkBox:CheckBoxListItemRenderer =
        CheckBoxListItemRenderer(event.itemRenderer)
    if (checkBox)
      selectedMedia = checkBox.selected ? null : Media(dataGrid.selectedItem)
  }
  event.preventDefault()
  dispatchEvent(new Event(Event.CHANGE))
}

protected function onRemoveMediaClick(event:MouseEvent):void {
  var indices:Array = mediaDataGrid.selectedIndices.sort(
      Array.DESCENDING | Array.NUMERIC)
  for each (var index:int in indices)
    media.removeItemAt(index)
}

protected function onFileSelectMultiple(event:FileListEvent):void {
  for each (var file:File in event.files)
    Media.createMedia(file, Poang.app.library)
}
