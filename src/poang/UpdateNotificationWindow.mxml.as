import dpk.GithubUpdater
import dpk.UpdateEvent
import dpk.WindowHelper
import mx.events.FlexEvent

protected var helper:WindowHelper
protected var preferences:Preferences
protected var updater:GithubUpdater

protected function onClose(event:Event):void {
  updater.removeEventListener(Event.CANCEL, onUpdateCancel)
  updater.removeEventListener(UpdateEvent.DOWNLOAD_STARTED,
      onUpdateDownloadStarted)
  updater.removeEventListener(UpdateEvent.UPDATE_AVAILABLE, onUpdateAvailable)
}

protected function onDownloadButtonClick(event:MouseEvent):void {
  updater.download()
}

protected function onIgnoreButtonClick(event:MouseEvent):void {
  close()
}

protected function onInitialize(event:FlexEvent):void {
  updater = Poang.app.updater
  updateAvailable()
  updater.addEventListener(Event.CANCEL, onUpdateCancel)
  updater.addEventListener(UpdateEvent.DOWNLOAD_STARTED,
      onUpdateDownloadStarted)
  updater.addEventListener(UpdateEvent.UPDATE_AVAILABLE, onUpdateAvailable)
  preferences = Poang.app.preferences
  helper = new WindowHelper('updateNotification', this, preferences)
}

protected function onUpdateAvailable(event:UpdateEvent):void {
  updateAvailable()
}

protected function onUpdateCancel(event:Event):void {
  activate()
}

protected function onUpdateDownloadStarted(event:UpdateEvent):void {
  close()
}

protected function updateAvailable():void {
  var updateInfo:XML = updater.updateInfo
  changeHTML.htmlText = updateInfo.changes
  messageLabel.text = 'An update to version ' + updateInfo.version +
      ' is available on the ' + updater.branch +
      ' release track. The following changes are included in this update:'
}
