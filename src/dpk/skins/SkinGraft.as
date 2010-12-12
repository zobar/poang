package dpk.skins {
  import flash.display.DisplayObjectContainer
  import mx.events.StateChangeEvent
  import mx.styles.IStyleClient

  public class SkinGraft extends Skin {
    override public function set owner(value:DisplayObjectContainer):void {
      if (value != owner) {
        if (owner) {
          owner.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,
              onOwnerCurrentStateChange)
        }
        super.owner = value
        if (owner) {
          owner.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,
              onOwnerCurrentStateChange)
        }
        styleChanged(null)
      }
    }
    
    override public function getStyle(styleName:String):* {
      if (owner && owner is IStyleClient)
        return IStyleClient(owner).getStyle(styleName)
      else
        return super.getStyle(styleName)
    }
    
    protected function onOwnerCurrentStateChange(event:StateChangeEvent):void {
      currentState = event.currentTarget.currentState
    }
  }
}
