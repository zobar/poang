package framsta {
  import flash.display.BitmapData
  import flash.display.MovieClip
  import poang.formatTime

  public dynamic class ScoreboardDisplay extends MovieClip {
    protected var values:Object

    public function update(newValues:Object):void {
      var property:String
      if (values) {
        for (property in newValues) {
          trace(property + ' -> ' + newValues[property])
          values[property] = newValues[property]
        }
      }
      else {
        for (property in newValues)
          trace(property + ' = ' + newValues[property])
        values = newValues
      }
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
      var jammerImagesVisible:Boolean = !value
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
      if ('homeJammerImagePlaceholder' in this)
        this.homeJammerImagePlaceholder.visible = jammerImagesVisible
      if ('visitorJammerImagePlaceholder' in this)
        this.visitorJammerImagePlaceholder.visible = jammerImagesVisible
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

    protected function updateHomeImage(value:BitmapData):void {
      if ('homeImagePlaceholder' in this)
        this.homeImagePlaceholder.bitmapData = value
      if ('homeNameField' in this)
        this.homeNameField.visible = !value
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
      if ('visitorNameField' in this)
        this.visitorNameField.visible = !value
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