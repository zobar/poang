import dpk.WindowHelper
import flash.desktop.Updater
import mx.events.FlexEvent

protected var helper:WindowHelper

protected function onInitialize(event:FlexEvent):void {
  helper = new WindowHelper('updateComplete', this,
      QCRGScoreboard.app.preferences)
}

protected function onLaterButtonClick(event:MouseEvent):void {
  close()
}

protected function onNowButtonClick(event:MouseEvent):void {
  QCRGScoreboard.app.updater.update()
}
