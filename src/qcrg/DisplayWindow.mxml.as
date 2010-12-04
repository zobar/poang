import flash.display.StageDisplayState
import flash.ui.Mouse
import mx.events.AIREvent
import mx.events.FlexEvent
import mx.events.FlexNativeWindowBoundsEvent

protected var windowChanged:Boolean

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
  _displayScreen = value;
  (nativeWindow ? nativeWindow : this).bounds = displayScreen.bounds
  title = 'Display on ' + QCRGScoreboard.app.screenToString(displayScreen)
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
}

protected function onWindowMove(event:FlexNativeWindowBoundsEvent):void {
  if (!windowChanged) {
    windowChanged = true
    callLater(updateScreen, [QCRGScoreboard.app.getScreenIndex(displayScreen)])
  }
}

protected function onWindowResize(event:FlexNativeWindowBoundsEvent):void {
  if (!windowChanged) {
    windowChanged = true
    callLater(updateScreen, [QCRGScoreboard.app.getScreenIndex(displayScreen)])
  }
}

protected function updateScreen(screenIndex:int):void {
  var app:QCRGScoreboard = QCRGScoreboard.app
  var otherDisplay:DisplayWindow
  var screen:Screen
  windowChanged = false
  app.updateScreens()
  screen = app.screens[screenIndex]
  if (screen) {
    otherDisplay = app.displayForScreen(screen)
    if (otherDisplay && otherDisplay != this)
      close()
    else if (!displayScreen.bounds.equals(screen.bounds))
      displayScreen = screen
  }
  else
    close()
}
