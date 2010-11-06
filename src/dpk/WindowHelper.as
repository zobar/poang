package dpk {
  import flash.display.NativeWindowDisplayState
  import flash.events.IEventDispatcher
  import flash.geom.Rectangle
  import mx.core.IWindow
  import mx.events.AIREvent
  import mx.events.FlexNativeWindowBoundsEvent

  public class WindowHelper {
    public function get name():String {
      return _name
    }
    protected var _name:String

    public function get window():IWindow {
      return _window
    }
    protected var _window:IWindow

    protected var preferences:Object

    public function WindowHelper(name:String, window:IWindow,
        preferences:Object) {
      _name = name
      this.preferences = preferences
      _window = window
      IEventDispatcher(window).addEventListener(AIREvent.WINDOW_COMPLETE,
          onWindowComplete)
    }

    protected function onWindowComplete(event:AIREvent):void {
      var w:IEventDispatcher = IEventDispatcher(window)
      w.removeEventListener(AIREvent.WINDOW_COMPLETE, onWindowComplete)
      if (preferences[name + 'WindowMaximized'])
        window.maximize()
      else {
        var windowBounds:Rectangle = preferences[name + 'Window']
        if (windowBounds)
          window.nativeWindow.bounds = windowBounds
      }
      w.addEventListener(FlexNativeWindowBoundsEvent.WINDOW_MOVE,
          onWindowMove)
      w.addEventListener(FlexNativeWindowBoundsEvent.WINDOW_RESIZE,
          onWindowResize)
    }

    protected function onWindowMove(event:FlexNativeWindowBoundsEvent):void {
      updateWindowPreferences(event.afterBounds)
    }

    protected function onWindowResize(event:FlexNativeWindowBoundsEvent):void {
      updateWindowPreferences(event.afterBounds)
    }

    protected function updateWindowPreferences(bounds:Rectangle):void {
      if (window.nativeWindow.displayState ==
          NativeWindowDisplayState.MAXIMIZED) {
        preferences[name + 'WindowMaximized'] = true
        preferences[name + 'Window'] = null
      }
      else {
        preferences[name + 'WindowMaximized'] = false
        preferences[name + 'Window'] = bounds
      }
    }
  }
}
