package qcrg {
  import dpk.minutes
  import dpk.seconds
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.utils.getTimer
  import mx.events.PropertyChangeEvent

  public class Bout extends EventDispatcher {
    [Bindable]
    public var intermissionClock:int

    [Bindable]
    public var intermissionLength:int

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

    public function Bout() {
      var app:QCRGScoreboard = QCRGScoreboard.app
      intermissionClock = 0
      intermissionLength = app.preferences.intermissionLength
      _jamClock = 0
      lastPeriod = 0
      leadJammer = Team.NONE
      _lineupClock = 0
      officialTimeout = false
      period = Period.NONE
      _periodClock = 0
      periodClockRunning = true
      timeoutClock = 0
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
            _periodClock = minutes(2)
            _lineupClock = minutes(1)
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
              jamClock = minutes(2)
              _lineupClock = 0
              homeJamScore = 0
              visitorJamScore = 0
            }
            else {
              // Start lineup
              _jamClock = 0
              leadJammer = Team.NONE
              if (_periodClock < seconds(30))
                _lineupClock = _periodClock
              else
                lineupClock = seconds(30)
            }
          }
          else {
            if (period == 2) {
              homeJamScore = 0
              visitorJamScore = 0
              if (homeScore == visitorScore) {
                // Go into overtime
                period = Period.OVERTIME
                _periodClock = minutes(2)
                _lineupClock = minutes(1)
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
                _periodClock = minutes(30)
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
  }
}
