package framsta {
  import flash.display.BitmapData

  public class Framsta extends ScoreboardDisplay {
    override protected function get jamVisible():Boolean {
      return super.jamVisible && values.jamClock && !values.lineupClock &&
          !values.timeoutClock
    }

    override protected function get timeoutsVisible():Boolean {
      return super.timeoutsVisible && !values.jamClock &&
          (values.lineupClock || values.timeoutClock) &&
          !values.homeJammerImage && !values.visitorJammerImage
    }

    override protected function get homeJammerImageVisible():Boolean {
      return super.homeJammerImageVisible && !values.leadJammer
    }

    override protected function get homeNameVisible():Boolean {
      return super.homeNameVisible && !values.homeImage
    }

    override protected function get visitorJammerImageVisible():Boolean {
      return super.visitorJammerImageVisible && !values.leadJammer
    }

    override protected function get visitorNameVisible():Boolean {
      return super.visitorNameVisible && !values.visitorImage
    }

    override protected function showHomeLeadJammer(visible:Boolean):void {
      super.showHomeLeadJammer(visible)
      if (visible)
        homeLeadJammerIndicator.gotoAndPlay(1)
      else
        homeLeadJammerIndicator.gotoAndStop(homeLeadJammerIndicator.totalFrames)
    }

    override protected function showVisitorLeadJammer(visible:Boolean):void {
      super.showVisitorLeadJammer(visible)
      if (visible)
        visitorLeadJammerIndicator.gotoAndPlay(1)
      else {
        visitorLeadJammerIndicator.gotoAndStop(
            visitorLeadJammerIndicator.totalFrames)
      }
    }

    override protected function updateJamClock(value:int):void {
      super.updateJamClock(value)
      showJam(jamVisible)
      showTimeouts(timeoutsVisible)
    }

    override protected function updateLeadJammer(value:String):void {
      super.updateLeadJammer(value)
      showHomeJammerImage(homeJammerImageVisible)
      showVisitorJammerImage(visitorJammerImageVisible)
    }

    override protected function updateLineupClock(value:int):void {
      super.updateLineupClock(value)
      showJam(jamVisible)
      showTimeouts(timeoutsVisible)
    }

    override protected function updateTimeoutClock(value:int):void {
      super.updateTimeoutClock(value)
      showJam(jamVisible)
      showTimeouts(timeoutsVisible)
    }

    override protected function updateHomeImage(value:BitmapData):void {
      super.updateHomeImage(value)
      showHomeName(homeNameVisible)
    }

    override protected function updateHomeJammerImage(value:BitmapData):void {
      super.updateHomeJammerImage(value)
      showTimeouts(timeoutsVisible)
    }

    override protected function updateVisitorImage(value:BitmapData):void {
      super.updateVisitorImage(value)
      showVisitorName(visitorNameVisible)
    }

    override protected function
        updateVisitorJammerImage(value:BitmapData):void {
      super.updateVisitorJammerImage(value)
      showTimeouts(timeoutsVisible)
    }
  }
}
