package qcrg {
  import flash.display.MovieClip
  import dpk.formatTime

  public dynamic class ScoreboardDisplay extends MovieClip {
    protected var values:Object

    public function update(newValues:Object):void {
      if (values) {
        for (var property:String in newValues)
          values[property] = newValues[property]
      }
      else
        values = newValues
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

      if ('homeJamScore' in newValues)
        updateHomeJamScore(newValues.homeJamScore)
      if ('homeScore' in newValues)
        updateHomeScore(newValues.homeScore)

      if ('visitorJamScore' in newValues)
        updateVisitorJamScore(newValues.visitorJamScore)
      if ('visitorScore' in newValues)
        updateVisitorScore(newValues.visitorScore)
    }

    protected function updateIntermissionClock(value:int):void {
      var visible:Boolean = value && values.period <= 0
      if ('intermissionClockField' in this) {
        var intermissionClockField:* = this.intermissionClockField
        intermissionClockField.text = formatTime(value)
        intermissionClockField.visible = visible
      }
      if ('intermissionClockLabel' in this)
        this.intermissionClockLabel.visible = visible
    }

    protected function updateJam(value:int):void {
      var visible:Boolean = Boolean(value)
      if ('jamField' in this) {
        var jamField:* = this.jamField
        jamField.text = value
        jamField.visible = visible
      }
      if ('jamLabel' in this)
        this.jamLabel.visible = visible
    }

    protected function updateJamClock(value:int):void {
      var visible:Boolean = value && !values.lineupClock && !values.timeoutClock
      if ('jamClockField' in this) {
        var jamClockField:* = this.jamClockField
        jamClockField.text = formatTime(value)
        jamClockField.visible = visible
      }
      if ('jamClockLabel' in this)
        this.jamClockLabel.visible = visible
    }

    protected function updateLeadJammer(value:String):void {
      if ('homeLeadJammerIndicator' in this) {
        var homeLeadJammerIndicator:MovieClip = this.homeLeadJammerIndicator
        if (value == Team.HOME) {
          homeLeadJammerIndicator.gotoAndPlay(1)
          homeLeadJammerIndicator.visible = true
        }
        else {
          homeLeadJammerIndicator.gotoAndStop(
              homeLeadJammerIndicator.totalFrames)
          homeLeadJammerIndicator.visible = false
        }
      }
      if ('visitorLeadJammerIndicator' in this) {
        var visitorLeadJammerIndicator:MovieClip =
            this.visitorLeadJammerIndicator
        if (value == Team.VISITOR) {
          visitorLeadJammerIndicator.gotoAndPlay(1)
          visitorLeadJammerIndicator.visible = true
        }
        else {
          visitorLeadJammerIndicator.gotoAndStop(
              visitorLeadJammerIndicator.totalFrames)
          visitorLeadJammerIndicator.visible = false
        }
      }
    }

    protected function updateLineupClock(value:int):void {
      var jamClock:int = values.jamClock
      var visible:Boolean = Boolean(value) && (!values.timeoutClock || values.period == Period.OVERTIME)
      var jamClockVisible:Boolean = jamClock && !value && !visible
      if ('jamClockField' in this)
        this.jamClockField.visible = jamClockVisible
      if ('jamClockLabel' in this)
        this.jamClockLabel.visible = jamClockVisible
      if ('lineupClockField' in this) {
        var lineupClockField:* = this.lineupClockField
        lineupClockField.text = formatTime(value)
        lineupClockField.visible = visible
      }
      if ('lineupClockLabel' in this)
        this.lineupClockLabel.visible = visible
    }

    protected function updatePeriod(value:int):void {
      var periodField:* = 'periodField' in this ? this.periodField : null
      var periodLabel:* = 'periodLabel' in this ? this.periodLabel : null
      var periodNumberField:* = 'periodNumberField' in this ?
          this.periodNumberField : null
      if (value > 0) {
        if (periodField)
          periodField.visible = false
        if (periodLabel)
          periodLabel.visible = true
        if (periodNumberField) {
          periodNumberField.text = value
          periodNumberField.visible = true
        }
      }
      else {
        if (periodField) {
          periodField.text = Period.toString(value)
          periodField.visible = true
        }
        if (periodLabel)
          periodLabel.visible = false
        if (periodNumberField)
          periodNumberField.visible = false
      }
    }

    protected function updatePeriodClock(value:int):void {
      var visible:Boolean = Boolean(value)
      if ('periodClockField' in this) {
        var periodClockField:* = this.periodClockField
        periodClockField.text = formatTime(value)
        periodClockField.visible = visible
      }
    }

    protected function updateTimeoutClock(value:int):void {
      var lineupClock:int = values.lineupClock
      var visible:Boolean = Boolean(value) && values.period != Period.OVERTIME
      var jamClockVisible:Boolean = values.jamClock && !lineupClock && !visible
      var lineupClockVisible:Boolean = lineupClock && !visible
      if ('jamClockField' in this)
        this.jamClockField.visible = jamClockVisible
      if ('jamClockLabel' in this)
        this.jamClockLabel.visible = jamClockVisible
      if ('lineupClockField' in this)
        this.lineupClockField.visible = lineupClockVisible
      if ('lineupClockLabel' in this)
        this.lineupClockLabel.visible = lineupClockVisible
      if ('timeoutClockField' in this) {
        var timeoutClockField:* = this.timeoutClockField
        timeoutClockField.text = formatTime(value)
        timeoutClockField.visible = visible
      }
      if ('timeoutClockLabel' in this)
        this.timeoutClockLabel.visible = visible
    }

    protected function updateHomeJamScore(value:int):void {
      if ('homeJamScoreField' in this)
        this.homeJamScoreField.text = value ? value : ''
    }

    protected function updateHomeScore(value:int):void {
      if ('homeScoreField' in this)
        this.homeScoreField.text = value
    }

    protected function updateVisitorJamScore(value:int):void {
      if ('visitorJamScoreField' in this)
        this.visitorJamScoreField.text = value ? value : ''
    }

    protected function updateVisitorScore(value:int):void {
      if ('visitorScoreField' in this)
        this.visitorScoreField.text = value
    }
  }
}
