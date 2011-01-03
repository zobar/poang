package dpk {
  import flash.display.NativeWindowDisplayState
  import flash.display.Stage
  import flash.events.Event
  import flash.events.IEventDispatcher
  import flash.geom.Rectangle
  import mx.core.IWindow
  import mx.core.UIComponent
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
      var w:IEventDispatcher = IEventDispatcher(window)
      _name = name
      this.preferences = preferences
      _window = window
      w.addEventListener(AIREvent.WINDOW_COMPLETE, onWindowComplete)
      w.addEventListener(Event.CLOSE, onWindowClose)
    }

    protected function onWindowClose(event:Event):void {
      var w:IEventDispatcher = IEventDispatcher(window)
      w.removeEventListener(AIREvent.WINDOW_COMPLETE, onWindowComplete)
      w.removeEventListener(Event.CLOSE, onWindowClose)
      w.removeEventListener(FlexNativeWindowBoundsEvent.WINDOW_MOVE,
          onWindowMove)
      w.removeEventListener(FlexNativeWindowBoundsEvent.WINDOW_RESIZE,
          onWindowResize)
    }

    protected function onWindowComplete(event:AIREvent):void {
      var w:IEventDispatcher = IEventDispatcher(window)
      w.removeEventListener(AIREvent.WINDOW_COMPLETE, onWindowComplete)
      if (preferences[name + 'WindowMaximized'])
        window.maximize()
      else {
        var windowBounds:Rectangle = preferences[name + 'Window']
        if (windowBounds) {
          var component:UIComponent = UIComponent(window)
          var stage:Stage = component.stage
          window.nativeWindow.bounds = windowBounds
          component.height = stage.stageHeight
          component.width = stage.stageWidth
        }
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
