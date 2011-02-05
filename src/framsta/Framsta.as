package framsta {
  import flash.display.BitmapData
  import flash.display.MovieClip

  public class Framsta extends ScoreboardDisplay {
    override public function get timeoutsVisible():Boolean {
      return super.timeoutsVisible && !bout.jamClock &&
          (bout.lineupClock || bout.timeoutClock) &&
          !bout.homeJammerImage && !bout.visitorJammerImage
    }

    override public function get homeJammerImageVisible():Boolean {
      return super.homeJammerImageVisible && !bout.leadJammer
    }

    override public function get homeNameVisible():Boolean {
      return super.homeNameVisible && !bout.homeImage
    }

    override public function get visitorJammerImageVisible():Boolean {
      return super.visitorJammerImageVisible && !bout.leadJammer
    }

    override public function get visitorNameVisible():Boolean {
      return super.visitorNameVisible && !bout.visitorImage
    }

    override protected function showHomeLeadJammer(visible:Boolean):void {
      var indicator:MovieClip = homeJammer.leadJammerIndicator
      super.showHomeLeadJammer(visible)
      if (indicator)
        indicator.visible = visible
      if (bout.leadJammer && homeJammer.currentFrameLabel != 'leadJammer')
        homeJammer.gotoAndPlay('startLeadJammer')
    }

    override protected function showVisitorLeadJammer(visible:Boolean):void {
      var indicator:MovieClip = visitorJammer.leadJammerIndicator
      super.showVisitorLeadJammer(visible)
      if (indicator)
        indicator.visible = visible
      if (bout.leadJammer && visitorJammer.currentFrameLabel != 'leadJammer')
        visitorJammer.gotoAndPlay('startLeadJammer')
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
      var placeholder:Placeholder = homeJammer.imagePlaceholder
      super.updateHomeJammerImage(value)
      if (placeholder)
        placeholder.bitmapData = value
      showTimeouts(timeoutsVisible)
    }

    override protected function updateHomeJammerName(value:String):void {
      var nameField = homeJammer.nameField
      super.updateHomeJammerName(value)
      if (value) {
        if (nameField)
          homeJammer.nameField.text = value
        if (homeJammer.currentFrame == homeJammer.totalFrames)
          homeJammer.gotoAndPlay(1)
      }
      else {
        if (nameField)
          homeJammer.nameField.text = ''
        if (!bout.leadJammer)
          homeJammer.gotoAndStop(homeJammer.totalFrames)
      }
    }

    override protected function updateVisitorImage(value:BitmapData):void {
      super.updateVisitorImage(value)
      showVisitorName(visitorNameVisible)
    }

    override protected function
        updateVisitorJammerImage(value:BitmapData):void {
      var placeholder:Placeholder = visitorJammer.imagePlaceholder
      super.updateVisitorJammerImage(value)
      if (placeholder)
        placeholder.bitmapData = value
      showTimeouts(timeoutsVisible)
    }

    override protected function updateVisitorJammerName(value:String):void {
      var nameField = visitorJammer.nameField
      super.updateVisitorJammerName(value)
      if (value) {
        if (nameField)
          visitorJammer.nameField.text = value
        if (visitorJammer.currentFrame == visitorJammer.totalFrames)
          visitorJammer.gotoAndPlay(1)
      }
      else {
        if (nameField)
          visitorJammer.nameField.text = ''
        if (!bout.leadJammer)
          visitorJammer.gotoAndStop(visitorJammer.totalFrames)
      }
    }
  }
}
