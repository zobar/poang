package dpk {
  import flash.events.IEventListener
  import mx.core.IFactory

  public class WindowManager implements IEventListener {
    protected var eventListeners:Array

    [Bindable] public var factory:IFactory

    public function WindowManager(factory:IFactory) {
      eventListeners = []
      this.factory = factory
    }

    public function addEventListener(type:String, listener:Function,
        useCapture:Boolean=false, priority:int=0,
        useWeakReference:Boolean=false):void {
      eventListeners.push({
        type: type,
        listener: listener,
        useCapture: useCapture,
        priority: priority,
        useWeakReference: useWeakReference
      })
      if (instance) {
        instance.addEventListener(type, listener, useCapture, priority,
            useWeakReference)
      }
    }
  }
}
