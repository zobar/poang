import dpk.GithubUpdater
import dpk.WindowHelper
import flash.system.Capabilities
import mx.collections.ArrayCollection
import mx.collections.IList
import mx.events.CollectionEvent
import mx.events.FlexEvent
import spark.components.supportClasses.ListBase
import spark.components.supportClasses.ToggleButtonBase

protected var helper:WindowHelper

[Bindable]
public var preferences:Preferences

[Bindable]
public function get releaseTrack():String {
  if (!_releaseTrack)
    _releaseTrack = preferences.releaseTrack
  return _releaseTrack
}
public function set releaseTrack(value:String):void {
  _releaseTrack = value
  preferences.releaseTrack = releaseTrack
  releaseTrackList.selectedItem = releaseTrack
}
protected var _releaseTrack:String

[Bindable]
public function get releaseTracks():ArrayCollection {
  if (!_releaseTracks) {
    _releaseTracks = updater.branches
    _releaseTracks.addEventListener(CollectionEvent.COLLECTION_CHANGE,
        onReleaseTracksCollectionChange)
  }
  return _releaseTracks
}
public function set releaseTracks(value:ArrayCollection):void {
  if (_releaseTracks) {
    _releaseTracks.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
        onReleaseTracksCollectionChange)
  }
  _releaseTracks = value
  if (_releaseTracks) {
    _releaseTracks.addEventListener(CollectionEvent.COLLECTION_CHANGE,
        onReleaseTracksCollectionChange)
  }
}
protected var _releaseTracks:ArrayCollection

[Bindable]
public var updater:GithubUpdater

protected function onAutoUpdateButtonChange(event:Event):void {
  preferences.autoUpdate = ToggleButtonBase(event.currentTarget).selected
}

protected function onCheckUpdateButtonClick(event:MouseEvent):void {
  updater.check()
}

protected function onCloseButtonClick(event:MouseEvent):void {
  close()
}

protected function onInitialize(event:FlexEvent):void {
  preferences = QCRGScoreboard.app.preferences
  helper = new WindowHelper('preferences', this, preferences)
  updater = QCRGScoreboard.app.updater
  releaseTrackList.dataProvider = releaseTracks
  releaseTrackList.selectedItem = releaseTrack
  if (/^Windows/.test(Capabilities.os))
    title = 'Settings'
  else
    title = 'Preferences'
}

protected function onReleaseTrackListChange(event:Event):void {
  releaseTrack = ListBase(event.currentTarget).selectedItem
}

protected function
    onReleaseTracksCollectionChange(event:CollectionEvent):void {
  trace('release tracks changing')
  releaseTrackList.selectedItem = releaseTrack
}
