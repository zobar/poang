package framsta {
  import flash.display.BitmapData

  public class Framsta extends ScoreboardDisplay {
    protected function get jamVisible():Boolean {
      return values.jam && values.jamClock && !values.lineupClock &&
          !values.timeoutClock
    }

    protected function get timeoutsVisible():Boolean {
      return values.period > 0 && !values.jamClock &&
          (values.lineupClock || values.timeoutClock) &&
          !values.homeJammerImage && !values.visitorJammerImage
    }

    override protected function updateJam(value:int):void {
      var jamVisible:Boolean = value && values.jamClock &&
          !values.lineupClock && !values.timeoutClock
      super.updateJam(value)
      jamLabel.visible = jamField.visible = jamVisible
    }

    override protected function updateJamClock(value:int):void {
      super.updateJamClock(value)
      jamLabel.visible = jamField.visible = jamVisible
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function updateLineupClock(value:int):void {
      super.updateLineupClock(value)
      jamLabel.visible = jamField.visible = jamVisible
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function updatePeriod(value:int):void {
      super.updatePeriod(value)
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function updateTimeoutClock(value:int):void {
      super.updateTimeoutClock(value)
      jamLabel.visible = jamField.visible = jamVisible
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function updateHomeJammerImage(value:BitmapData):void {
      super.updateHomeJammerImage(value)
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function
        updateVisitorJammerImage(value:BitmapData):void {
      super.updateVisitorJammerImage(value)
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }
  }
}
