import dpk.CheckBoxListItemRenderer
import flash.display.LoaderInfo
import flash.events.Event
import flash.events.FileListEvent
import flash.events.TimerEvent
import flash.filesystem.File
import flash.geom.Rectangle
import flash.utils.Timer
import mx.collections.ArrayCollection
import mx.events.DataGridEvent

[Bindable]
public function get currentMedia():Media {
  return _currentMedia
}
public function set currentMedia(value:Media):void {
  var content:DisplayObject
  if (currentMedia) {
    content = currentMedia.content
    if (content is MovieClip) {
      var movieClip:MovieClip = MovieClip(content)
      movieClip.gotoAndStop(movieClip.totalFrames)
    }
  }
  _currentMedia = value
  if (currentMedia) {
    content = currentMedia.content
    if (content is MovieClip)
      MovieClip(content).gotoAndPlay(1)
  }
}
protected var _currentMedia:Media

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
  return currentMedia
}
public function set selectedMedia(value:Media):void {
  if (slideShowMedia || value != currentMedia) {
    if (slideShowMedia) {
      for (var i:int = 0; i < slideShowMedia.length; ++i) {
        var media:Media = Media(slideShowMedia.getItemAt(i))
        media.show = (media == value)
      }
    }
    else if (selectedMedia)
      selectedMedia.show = false
    slideShowMedia = null
    currentMedia = value
    if (selectedMedia)
      selectedMedia.show = true
  }
}

public function get slideShowLength():int {
  return _slideShowLength
}
public function set slideShowLength(value:int):void {
  _slideShowLength = value
  if (slideShowTimer)
    slideShowTimer.delay = value
}
protected var _slideShowLength:int

protected function get slideShowMedia():ArrayCollection {
  return _slideShowMedia
}
protected function set slideShowMedia(value:ArrayCollection):void {
  _slideShowMedia = value
  if (value) {
    if (!slideShowTimer)
      slideShowTimer = new Timer(slideShowLength)
    slideShowTimer.start()
  }
  else if (slideShowTimer)
    slideShowTimer.stop()
}
protected var _slideShowMedia:ArrayCollection

protected function get slideShowTimer():Timer {
  return _slideShowTimer
}
protected function set slideShowTimer(value:Timer):void {
  if (slideShowTimer) {
    slideShowTimer.removeEventListener(TimerEvent.TIMER, onSlideShowTimer)
    slideShowTimer.stop()
  }
  _slideShowTimer = value
  if (slideShowTimer) {
    slideShowTimer.delay = slideShowLength
    slideShowTimer.repeatCount = 0
    slideShowTimer.addEventListener(TimerEvent.TIMER, onSlideShowTimer)
  }
}
protected var _slideShowTimer:Timer

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
    if (checkBox) {
      if (slideShowMedia || !checkBox.selected) {
        selectedMedia = null
        selectedMedia = Media(dataGrid.selectedItem)
      }
      else
        selectedMedia = Media(media.getItemAt(0))
    }
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

protected function onSlideShowClick(event:MouseEvent):void {
  var change:Boolean = true
  var indices:Array = mediaDataGrid.selectedIndices.sort(Array.NUMERIC)
  slideShowMedia = new ArrayCollection()
  for each (var index:int in indices) {
    var m:Media = Media(media.getItemAt(index))
    m.show = true
    slideShowMedia.addItem(m)
    if (m == currentMedia)
      change = false
  }
  if (change) {
    currentMedia.show = false
    currentMedia = Media(slideShowMedia.getItemAt(0))
    dispatchEvent(new Event(Event.CHANGE))
  }
}

protected function nextSlide(fromIndex:int):Media {
  for (var i:int = fromIndex; i < media.length; ++i) {
    var m:Media = Media(media.getItemAt(i))
    if (m.show)
      return m
  }
  return null
}

protected function onSlideShowTimer(event:Event):void {
  currentMedia = nextSlide(media.getItemIndex(currentMedia) + 1) || nextSlide(0)
  dispatchEvent(new Event(Event.CHANGE))
}
