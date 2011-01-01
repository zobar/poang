package poang {
  public class QueenCity3 extends ScoreboardDisplay {
    override protected function updateJam(value:int):void {
      var jamVisible:Boolean = value && values.jamClock &&
          !values.lineupClock && !values.timeoutClock
      super.updateJam(value)
      jamLabel.visible = jamField.visible = jamVisible
    }

    override protected function updateJamClock(value:int):void {
      var jamVisible:Boolean = values.jam && value && !values.lineupClock &&
          !values.timeoutClock
      var timeoutsVisible:Boolean = values.period > 0 && !value &&
          (values.lineupClock || values.timeoutClock)
      super.updateJamClock(value)
      jamLabel.visible = jamField.visible = jamVisible
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function updateLineupClock(value:int):void {
      var jamVisible:Boolean = values.jam && values.jamClock && !value &&
          !values.timeoutClock
      var timeoutsVisible:Boolean = values.period > 0 && !values.jamClock &&
          (value || values.timeoutClock)
      super.updateLineupClock(value)
      jamLabel.visible = jamField.visible = jamVisible
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function updatePeriod(value:int):void {
      var timeoutsVisible:Boolean = value > 0 && !values.jamClock &&
          (values.lineupClock || values.timeoutClock)
      super.updatePeriod(value)
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }

    override protected function updateTimeoutClock(value:int):void {
      var jamVisible:Boolean = values.jam && values.jamClock &&
          !values.lineupClock && !value
      var timeoutsVisible:Boolean = values.period > 0 && !values.jamClock &&
          (values.lineupClock || value)
      super.updateTimeoutClock(value)
      jamLabel.visible = jamField.visible = jamVisible
      homeTimeoutsField.visible = timeoutsLabel.visible =
          visitorTimeoutsField.visible = timeoutsVisible
    }
  }
}
