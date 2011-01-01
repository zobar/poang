import mx.collections.ArrayCollection
import spark.events.IndexChangeEvent

[Bindable]
public function get ruleset():Ruleset {
  if (!_ruleset)
    _ruleset = Ruleset(QCRGScoreboard.app.preferences.ruleset)
  return _ruleset
}
public function set ruleset(value:Ruleset):void {
  _ruleset = value
}
protected var _ruleset:Ruleset

[Bindable] public var target:*

[Bindable]
public function get timeoutsPer():ArrayCollection {
  if (!_timeoutsPer)
    _timeoutsPer = new ArrayCollection([Timeout.PER_BOUT, Timeout.PER_PERIOD])
  return _timeoutsPer
}
public function set timeoutsPer(value:ArrayCollection):void {
  _timeoutsPer = value
}
protected var _timeoutsPer:ArrayCollection

protected function commitField(property:String, parse:*, field:Object):void {
  target[property] = parse(TextInput(field).text)
  field.selectAll()
}

protected function onIntermissionLengthEvent(event:Event):void {
  commitField('intermissionLength', parseTime, event.currentTarget)
}

protected function onJamLengthEvent(event:Event):void {
  commitField('jamLength', parseTime, event.currentTarget)
}

protected function onLineupLengthEvent(event:Event):void {
  commitField('lineupLength', parseTime, event.currentTarget)
}

protected function onOvertimeLineupLengthEvent(event:Event):void {
  commitField('overtimeLineupLength', parseTime, event.currentTarget)
}

protected function onPeriodLengthEvent(event:Event):void {
  commitField('periodLength', parseTime, event.currentTarget)
}

protected function onPeriodsEvent(event:Event):void {
  commitField('periods', parseInt, event.currentTarget)
}

protected function onTimeoutsEvent(event:Event):void {
  commitField('timeouts', parseInt, event.currentTarget)
}

protected function onTimeoutLengthEvent(event:Event):void {
  commitField('timeoutLength', parseTime, event.currentTarget)
}

protected function onResetAllClick(event:MouseEvent):void {
  for each (var name:String in Ruleset.ruleNames)
    target[name] = ruleset[name]
}

protected function onResetIntermissionLengthClick(event:MouseEvent):void {
  resetField('intermissionLength')
}

protected function onResetJamLengthClick(event:MouseEvent):void {
  resetField('jamLength')
}

protected function onResetLineupLengthClick(event:MouseEvent):void {
  resetField('lineupLength')
}

protected function onResetOvertimeLineupLengthClick(event:MouseEvent):void {
  resetField('overtimeLineupLength')
}

protected function onResetPeriodLengthClick(event:MouseEvent):void {
  resetField('periodLength')
}

protected function onResetPeriodsClick(event:MouseEvent):void {
  resetField('periods')
}

protected function onResetTimeoutsClick(event:MouseEvent):void {
  resetField('timeouts')
  resetField('timeoutsPer')
}

protected function onResetTimeoutLengthClick(event:MouseEvent):void {
  resetField('timeoutLength')
}

protected function onTimeoutsPerChange(event:IndexChangeEvent):void {
  target.timeoutsPer = DropDownList(event.currentTarget).selectedItem
}

protected function resetField(name:String):void {
  target[name] = ruleset[name]
}
