package dpk {
  import flash.events.Event

  public class UpdateEvent extends Event {
    public static const DOWNLOAD_STARTED:String = 'downloadStarted'
    public static const UPDATE_AVAILABLE:String = 'updateAvailable'

    public function UpdateEvent(type:String, bubbles:Boolean=false,
        cancelable:Boolean=false) {
      super(type, bubbles, cancelable)
    }
  }
}
