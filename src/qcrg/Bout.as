package qcrg {
  import flash.events.Event
  import flash.utils.getTimer
  import mx.events.PropertyChangeEvent

  public class Bout extends AbstractRuleset {
    protected static var lastUntitledNumber:int

    [Bindable]
    public var intermissionClock:int

    [Bindable]
    public var jam:int

    [Bindable]
    public function get jamClock():int {
      return _jamClock
    }
    public function set jamClock(value:int):void {
      _jamClock = fudge(value)
    }
    protected var _jamClock:int

    protected var lastPeriod:int
    protected var lastTick:int

    [Bindable]
    public function get leadJammer():String {
      return _leadJammer
    }
    public function set leadJammer(value:String):void {
      if (jamClock)
        _leadJammer = value
      else
        _leadJammer = Team.NONE
    }
    protected var _leadJammer:String

    [Bindable]
    public function get lineupClock():int {
      return _lineupClock
    }
    public function set lineupClock(value:int):void {
      _lineupClock = fudge(value)
    }
    protected var _lineupClock:int

    [Bindable]
    public var officialTimeout:Boolean

    [Bindable]
    public var period:int

    [Bindable]
    public function get periodClock():int {
      return _periodClock
    }
    public function set periodClock(value:int):void {
      _periodClock = fudge(value)
    }
    protected var _periodClock:int

    protected var periodClockRunning:Boolean

    [Bindable]
    public var timeoutClock:int

    [Bindable]
    public function get name():String {
      if (_name == null)
        _name = 'Untitled Bout ' + (++lastUntitledNumber)
      return _name
    }
    public function set name(value:String):void {
      _name = value
    }
    protected var _name:String

    [Bindable]
    public function get homeJamScore():int {
      return _homeJamScore
    }
    public function set homeJamScore(value:int):void {
      _homeJamScore = Math.max(value, 0)
    }
    protected var _homeJamScore:int

    [Bindable]
    public function get homeScore():int {
      return _homeScore
    }
    public function set homeScore(value:int):void {
      _homeScore = Math.max(value, 0)
    }
    protected var _homeScore:int

    [Bindable]
    public function get homeTeam():Team {
      return _homeTeam
    }
    public function set homeTeam(value:Team):void {
      _homeTeam = value
    }
    protected var _homeTeam:Team

    [Bindable]
    public function get visitorJamScore():int {
      return _visitorJamScore
    }
    public function set visitorJamScore(value:int):void {
      _visitorJamScore = Math.max(value, 0)
    }
    protected var _visitorJamScore:int

    [Bindable]
    public function get visitorScore():int {
      return _visitorScore
    }
    public function set visitorScore(value:int):void {
      _visitorScore = Math.max(value, 0)
    }
    protected var _visitorScore:int

    [Bindable]
    public function get visitorTeam():Team {
      return _visitorTeam
    }
    public function set visitorTeam(value:Team):void {
      _visitorTeam = value
    }
    protected var _visitorTeam:Team

    public function get propertiesWindow():PropertiesWindow {
      return _propertiesWindow
    }
    public function set propertiesWindow(value:PropertiesWindow):void {
      if (propertiesWindow) {
        propertiesWindow.removeEventListener(Event.CLOSE,
            onPropertiesWindowClose)
      }
      _propertiesWindow = value
      if (propertiesWindow)
        propertiesWindow.addEventListener(Event.CLOSE, onPropertiesWindowClose)
    }
    protected var _propertiesWindow:PropertiesWindow

    public function Bout() {
      var app:QCRGScoreboard = QCRGScoreboard.app
      var preferences:Preferences = app.preferences
      homeTeam = new Team()
      homeTeam.name = Team.HOME
      intermissionClock = 0
      _jamClock = 0
      lastPeriod = 0
      leadJammer = Team.NONE
      _lineupClock = 0
      officialTimeout = false
      period = Period.NONE
      _periodClock = 0
      periodClockRunning = true
      timeoutClock = 0
      visitorTeam = new Team()
      visitorTeam.name = Team.VISITOR
      for each (var rule:String in Ruleset.ruleNames)
        this[rule] = preferences[rule]
      app.addEventListener(Event.ENTER_FRAME, onEnterFrame)
    }

    public function advance():void {
      if (period != Period.FINAL) {
        var oldJamClock:int = _jamClock
        var oldLineupClock:int = _lineupClock
        var oldPeriodClock:int = _periodClock
        officialTimeout = false
        if (period == Period.OVERTIME) {
          if (_jamClock) {
            // OT: End jam
            _periodClock = 0
            _jamClock = 0
          }
          else if (_periodClock) {
            // OT: Start jam
            jam += 1
            _jamClock = _periodClock
            _lineupClock = 0
            homeJamScore = 0
            visitorJamScore = 0
          }
          else if (homeScore == visitorScore) {
            // OT: Start lineup
            _periodClock = jamLength
            _lineupClock = overtimeLineupLength
          }
          else {
            // OT: End game
            period = Period.FINAL
            homeJamScore = 0
            visitorJamScore = 0
          }
        }
        else {
          if (_jamClock || _periodClock) {
            if (_lineupClock || (_periodClock && !periodClockRunning)) {
              // Start next jam
              jam += 1
              jamClock = jamLength
              _lineupClock = 0
              homeJamScore = 0
              visitorJamScore = 0
            }
            else {
              // Start lineup
              _jamClock = 0
              leadJammer = Team.NONE
              if (_periodClock < lineupLength)
                _lineupClock = _periodClock
              else
                lineupClock = lineupLength
            }
          }
          else {
            if (period == periods) {
              homeJamScore = 0
              visitorJamScore = 0
              if (homeScore == visitorScore) {
                // Go into overtime
                period = Period.OVERTIME
                _periodClock = jamLength
                _lineupClock = overtimeLineupLength
                timeoutClock = 0
              }
              else {
                // End game
                period = Period.FINAL
              }
            }
            else {
              jam = 0
              if (period > 0) {
                // Start intermission
                intermissionClock = intermissionLength
                period = Period.INTERMISSION
              }
              else {
                // Start next period
                period = lastPeriod + 1
                lastPeriod = period
                _periodClock = periodLength
                intermissionClock = 0
              }
            }
          }
        }
        periodClockRunning = Boolean(jamClock) || Boolean(lineupClock)
        clockChanged('jamClock', oldJamClock)
        clockChanged('lineupClock', oldLineupClock)
        clockChanged('periodClock', oldPeriodClock)
      }
    }

    public function editProperties():void {
      if (propertiesWindow)
        propertiesWindow.activate()
      else {
        propertiesWindow = new PropertiesWindow()
        propertiesWindow.bout = this
        propertiesWindow.open()
        propertiesWindow.setFocus()
      }
    }

    protected function clockChanged(clock:String, oldValue:int):void {
      var newValue:int = this[clock]
      if (newValue != oldValue) {
        dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, clock,
            oldValue, newValue))
      }
    }

    protected function fudge(value:int):int {
      var fudge:int = _periodClock % 1000
      if (fudge > 500)
        fudge -= 1000
      return value - (value % 1000) + fudge
    }

    protected function onEnterFrame(event:Event):void {
      var now:int = getTimer()
      if (!officialTimeout) {
        var elapsed:int = now - lastTick
        var oldJamClock:int = _jamClock
        var oldLineupClock:int = _lineupClock
        var oldPeriodClock:int = _periodClock
        if (period == Period.OVERTIME) {
          if (_lineupClock) {
            _lineupClock = Math.max(_lineupClock - elapsed, 0)
            clockChanged('lineupClock', oldLineupClock)
          }
          else if (_jamClock) {
            if (_periodClock) {
              _periodClock = Math.max(_periodClock - elapsed, 0)
              clockChanged('periodClock', oldPeriodClock)
            }
            _jamClock = Math.max(_jamClock - elapsed, 0)
            clockChanged('jamClock', oldJamClock)
          }
        }
        else if (period > 0) {
          if (_periodClock && periodClockRunning && !timeoutClock) {
            _periodClock = Math.max(_periodClock - elapsed, 0)
            clockChanged('periodClock', oldPeriodClock)
          }
          if (timeoutClock) {
            timeoutClock = Math.max(timeoutClock - elapsed, 0)
            if (!timeoutClock)
              periodClockRunning = Boolean(_jamClock) || Boolean(_lineupClock)
          }
          else if (_lineupClock) {
            _lineupClock = Math.max(_lineupClock - elapsed, 0)
            if (!_lineupClock)
              periodClockRunning = Boolean(_jamClock)
            clockChanged('lineupClock', oldLineupClock)
          }
          else if (_jamClock) {
            _jamClock = Math.max(_jamClock - elapsed, 0)
            clockChanged('jamClock', oldJamClock)
          }
        }
        else if (intermissionClock)
          intermissionClock = Math.max(intermissionClock - elapsed, 0)
      }
      lastTick = now
    }

    protected function onPropertiesWindowClose(event:Event):void {
      propertiesWindow = null
    }
  }
}
