package framsta {
  import flash.display.BitmapData
  import flash.display.MovieClip
  import poang.formatTime

  public dynamic class ScoreboardDisplay extends MovieClip {
    public var bout:Object

    public function get intermissionClockVisible():Boolean {
      return bout.intermissionClock && bout.period <= 0
    }

    public function get jamClockVisible():Boolean {
      return bout.jamClock && !bout.lineupClock && !bout.timeoutClock
    }

    public function get jamVisible():Boolean {
      return bout.period && bout.jam
    }

    public function get lineupClockVisible():Boolean {
      return bout.lineupClock &&
          (!bout.timeoutClock || bout.period == Period.OVERTIME)
    }

    public function get periodClockVisible():Boolean {
      return bout.periodClock
    }

    public function get periodVisible():Boolean {
      return bout.period <= 0
    }

    public function get periodNumberVisible():Boolean {
      return bout.period > 0
    }

    public function get timeoutClockVisible():Boolean {
      return bout.timeoutClock && bout.period != Period.OVERTIME
    }

    public function get timeoutsVisible():Boolean {
      return bout.period > 0
    }

    public function get homeJammerImageVisible():Boolean {
      return true
    }

    public function get homeLeadJammerVisible():Boolean {
      return bout.leadJammer == Team.HOME
    }

    public function get homeNameVisible():Boolean {
      return true
    }

    public function get visitorJammerImageVisible():Boolean {
      return true
    }

    public function get visitorLeadJammerVisible():Boolean {
      return bout.leadJammer == Team.VISITOR
    }

    public function get visitorNameVisible():Boolean {
      return true
    }

    public function update(newValues:Object):void {
      if (bout) {
        for (var property:String in newValues)
          bout[property] = newValues[property]
      }
      else
        bout = newValues

      if ('intermissionClock' in newValues)
        updateIntermissionClock(newValues.intermissionClock)
      if ('jam' in newValues)
        updateJam(newValues.jam)
      if ('jamClock' in newValues)
        updateJamClock(newValues.jamClock)
      if ('leadJammer' in newValues)
        updateLeadJammer(newValues.leadJammer)
      if ('lineupClock' in newValues)
        updateLineupClock(newValues.lineupClock)
      if ('period' in newValues)
        updatePeriod(newValues.period)
      if ('periodClock' in newValues)
        updatePeriodClock(newValues.periodClock)
      if ('timeoutClock' in newValues)
        updateTimeoutClock(newValues.timeoutClock)

      if ('homeImage' in newValues)
        updateHomeImage(newValues.homeImage)
      if ('homeJammerImage' in newValues)
        updateHomeJammerImage(newValues.homeJammerImage)
      if ('homeJammerName' in newValues)
        updateHomeJammerName(newValues.homeJammerName)
      if ('homeJammerNumber' in newValues)
        updateHomeJammerNumber(newValues.homeJammerNumber)
      if ('homeJamScore' in newValues)
        updateHomeJamScore(newValues.homeJamScore)
      if ('homeName' in newValues)
        updateHomeName(newValues.homeName)
      if ('homeScore' in newValues)
        updateHomeScore(newValues.homeScore)
      if ('homeTimeouts' in newValues)
        updateHomeTimeouts(newValues.homeTimeouts)

      if ('visitorImage' in newValues)
        updateVisitorImage(newValues.visitorImage)
      if ('visitorJammerImage' in newValues)
        updateVisitorJammerImage(newValues.visitorJammerImage)
      if ('visitorJammerName' in newValues)
        updateVisitorJammerName(newValues.visitorJammerName)
      if ('visitorJammerNumber' in newValues)
        updateVisitorJammerNumber(newValues.visitorJammerNumber)
      if ('visitorJamScore' in newValues)
        updateVisitorJamScore(newValues.visitorJamScore)
      if ('visitorName' in newValues)
        updateVisitorName(newValues.visitorName)
      if ('visitorScore' in newValues)
        updateVisitorScore(newValues.visitorScore)
      if ('visitorTimeouts' in newValues)
        updateVisitorTimeouts(newValues.visitorTimeouts)
    }

    protected function formatTime(value:int):String {
      return poang.formatTime(value)
    }

    protected function showIntermissionClock(visible:Boolean):void {
      if ('intermissionClockField' in this)
        this.intermissionClockField.visible = visible
      if ('intermissionClockLabel' in this)
        this.intermissionClockLabel.visible = visible
    }

    protected function showJam(visible:Boolean):void {
      if ('jamField' in this)
        this.jamField.visible = visible
      if ('jamLabel' in this)
        this.jamLabel.visible = visible
    }

    protected function showJamClock(visible:Boolean):void {
      if ('jamClockField' in this)
        this.jamClockField.visible = visible
      if ('jamClockLabel' in this)
        this.jamClockLabel.visible = visible
    }

    protected function showLineupClock(visible:Boolean):void {
      if ('lineupClockField' in this)
        this.lineupClockField.visible = visible
      if ('lineupClockLabel' in this)
        this.lineupClockLabel.visible = visible
    }

    protected function showPeriod(visible:Boolean):void {
      if ('periodField' in this)
        this.periodField.visible = visible
    }

    protected function showPeriodClock(visible:Boolean):void {
      if ('periodClockField' in this)
        this.periodClockField.visible = visible
    }

    protected function showPeriodNumber(visible:Boolean):void {
      if ('periodNumberField' in this)
        this.periodNumberField.visible = visible
      if ('periodLabel' in this)
        this.periodLabel.visible = visible
    }

    protected function showTimeoutClock(visible:Boolean):void {
      if ('timeoutClockField' in this)
        this.timeoutClockField.visible = visible
      if ('timeoutClockLabel' in this)
        this.timeoutClockLabel.visible = visible
    }

    protected function showTimeouts(visible:Boolean):void {
      if ('timeoutsLabel' in this)
        this.timeoutsLabel.visible = visible
      if ('homeTimeoutsField' in this)
        this.homeTimeoutsField.visible = visible
      if ('visitorTimeoutsField' in this)
        this.visitorTimeoutsField.visible = visible
    }

    protected function showHomeJammerImage(visible:Boolean):void {
      if ('homeJammerImagePlaceholder' in this)
        this.homeJammerImagePlaceholder.visible = visible
    }

    protected function showHomeJammerName(visible:Boolean):void {
      if ('homeJammerNameField' in this)
        this.homeJammerNameField.visible = visible
    }

    protected function showHomeLeadJammer(visible:Boolean):void {
      if ('homeLeadJammerIndicator' in this)
        this.homeLeadJammerIndicator.visible = visible
    }

    protected function showHomeName(visible:Boolean):void {
      if ('homeNameField' in this)
        this.homeNameField.visible = visible
    }

    protected function showVisitorJammerImage(visible:Boolean):void {
      if ('visitorJammerImagePlaceholder' in this)
        this.visitorJammerImagePlaceholder.visible = visible
    }

    protected function showVisitorJammerName(visible:Boolean):void {
      if ('visitorJammerNameField' in this)
        this.visitorJammerNameField.visible = visible
    }

    protected function showVisitorLeadJammer(visible:Boolean):void {
      if ('visitorLeadJammerIndicator' in this)
        this.visitorLeadJammerIndicator.visible = visible
    }

    protected function showVisitorName(visible:Boolean):void {
      if ('visitorNameField' in this)
        this.visitorNameField.visible = visible
    }

    protected function updateIntermissionClock(value:int):void {
      if ('intermissionClockField' in this)
        this.intermissionClockField.text = formatTime(value)
      showIntermissionClock(intermissionClockVisible)
    }

    protected function updateJam(value:int):void {
      if ('jamField' in this)
        this.jamField.text = value
      showJam(jamVisible)
    }

    protected function updateJamClock(value:int):void {
      if ('jamClockField' in this)
        this.jamClockField.text = formatTime(value)
      showJamClock(jamClockVisible)
    }

    protected function updateLeadJammer(value:String):void {
      showHomeLeadJammer(homeLeadJammerVisible)
      showVisitorLeadJammer(visitorLeadJammerVisible)
    }

    protected function updateLineupClock(value:int):void {
      if ('lineupClockField' in this)
        this.lineupClockField.text = formatTime(value)
      showJamClock(jamClockVisible)
      showLineupClock(lineupClockVisible)
    }

    protected function updatePeriod(value:int):void {
      if (value > 0)
        this.periodNumberField.text = value
      this.periodField.text = Period.toString(value)
      showIntermissionClock(intermissionClockVisible)
      showLineupClock(lineupClockVisible)
      showPeriod(periodVisible)
      showPeriodNumber(periodNumberVisible)
      showTimeoutClock(timeoutClockVisible)
      showTimeouts(timeoutsVisible)
    }

    protected function updatePeriodClock(value:int):void {
      if ('periodClockField' in this)
        this.periodClockField.text = formatTime(value)
      showPeriodClock(periodClockVisible)
    }

    protected function updateTimeoutClock(value:int):void {
      if ('timeoutClockField' in this)
        this.timeoutClockField.text = formatTime(value)
      showJamClock(jamClockVisible)
      showLineupClock(lineupClockVisible)
      showTimeoutClock(timeoutClockVisible)
    }

    protected function updateHomeImage(value:BitmapData):void {
      if ('homeImagePlaceholder' in this)
        this.homeImagePlaceholder.bitmapData = value
    }

    protected function updateHomeJammerImage(value:BitmapData):void {
      if ('homeJammerImagePlaceholder' in this)
        this.homeJammerImagePlaceholder.bitmapData = value
    }

    protected function updateHomeJammerName(value:String):void {
      if ('homeJammerNameField' in this)
        this.homeJammerNameField.text = value ? value : ''
    }

    protected function updateHomeJammerNumber(value:String):void {
      if ('homeJammerNumberField' in this)
        this.homeJammerNumberField.text = value ? value : ''
    }

    protected function updateHomeJamScore(value:int):void {
      if ('homeJamScoreField' in this)
        this.homeJamScoreField.text = value ? value : ''
    }

    protected function updateHomeName(value:String):void {
      if ('homeNameField' in this)
        this.homeNameField.text = value
    }

    protected function updateHomeScore(value:int):void {
      if ('homeScoreField' in this)
        this.homeScoreField.text = value
    }

    protected function updateHomeTimeouts(value:int):void {
      if ('homeTimeoutsField' in this)
        this.homeTimeoutsField.text = value
    }

    protected function updateVisitorImage(value:BitmapData):void {
      if ('visitorImagePlaceholder' in this)
        this.visitorImagePlaceholder.bitmapData = value
    }

    protected function updateVisitorJammerImage(value:BitmapData):void {
      if ('visitorJammerImagePlaceholder' in this)
        this.visitorJammerImagePlaceholder.bitmapData = value
    }

    protected function updateVisitorJammerName(value:String):void {
      if ('visitorJammerNameField' in this)
        this.visitorJammerNameField.text = value ? value : ''
    }

    protected function updateVisitorJammerNumber(value:String):void {
      if ('visitorJammerNumberField' in this)
        this.visitorJammerNumberField.text = value ? value : ''
    }

    protected function updateVisitorJamScore(value:int):void {
      if ('visitorJamScoreField' in this)
        this.visitorJamScoreField.text = value ? value : ''
    }

    protected function updateVisitorName(value:String):void {
      if ('visitorNameField' in this)
        this.visitorNameField.text = value
    }

    protected function updateVisitorScore(value:int):void {
      if ('visitorScoreField' in this)
        this.visitorScoreField.text = value
    }

    protected function updateVisitorTimeouts(value:int):void {
      if ('visitorTimeoutsField' in this)
        this.visitorTimeoutsField.text = value
    }
  }
}
