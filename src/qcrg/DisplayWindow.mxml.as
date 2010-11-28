import flash.display.StageDisplayState
import flash.ui.Mouse
import mx.events.AIREvent
import mx.events.FlexEvent
import mx.events.FlexNativeWindowBoundsEvent

[Bindable]
public function get displayGroup():DisplayGroup {
  return _displayGroup
}
public function set displayGroup(value:DisplayGroup):void {
  _displayGroup = value
  if (display)
    display.group = _displayGroup
}
protected var _displayGroup:DisplayGroup

[Bindable]
public function get displayScreen():Screen {
  return _displayScreen
}
public function set displayScreen(value:Screen):void {
  _displayScreen = value
  bounds = displayScreen.bounds
  updateTitle()
}
protected var _displayScreen:Screen

protected function onClose(event:Event):void {
  display.group = null
}

protected function onDisplayCreationComplete(event:FlexEvent):void {
  Display(event.currentTarget).group = displayGroup
}

protected function onRollOut(event:MouseEvent):void {
  Mouse.show()
}

protected function onRollOver(event:MouseEvent):void {
  Mouse.hide()
}

protected function onWindowActivate(event:AIREvent):void {
  QCRGScoreboard.app.activate()
}

protected function onWindowComplete(event:AIREvent):void {
  nativeWindow.bounds = displayScreen.bounds
  stage.displayState = StageDisplayState.FULL_SCREEN
  addEventListener(FlexNativeWindowBoundsEvent.WINDOW_MOVE, onWindowMove)
  addEventListener(FlexNativeWindowBoundsEvent.WINDOW_RESIZE, onWindowResize)
}

protected function onWindowMove(event:FlexNativeWindowBoundsEvent):void {
  callLater(close)
  QCRGScoreboard.app.updateScreens()
}

protected function onWindowResize(event:FlexNativeWindowBoundsEvent):void {
  displayScreen = Screen.getScreensForRectangle(event.afterBounds)[0]
  height = stage.stageHeight
  width = stage.stageWidth
  QCRGScoreboard.app.updateScreens()
  updateTitle()
}

protected function updateTitle():void {
  title = 'Display on ' + QCRGScoreboard.app.screenToString(displayScreen)
}
