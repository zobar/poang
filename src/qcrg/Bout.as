package qcrg {
  import dpk.formatTime
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

    protected var lastTick:int

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
    public var periodClock:int

    protected var periodClockRunning:Boolean

    [Bindable]
    public var timeoutClock:int

    [Bindable]
    public var homeScore:int

    [Bindable]
    public var visitorScore:int

    public function Bout() {
      var app:QCRGScoreboard = QCRGScoreboard.app
      intermissionClock = 0
      intermissionLength = app.preferences.intermissionLength
      _jamClock = 0
      _lineupClock = 0
      officialTimeout = false
      period = Period.NONE
      periodClock = 0
      periodClockRunning = true
      timeoutClock = 0
      app.addEventListener(Event.ENTER_FRAME, onEnterFrame)
    }

    public function advance():void {
      if (period != Period.FINAL) {
        var oldJamClock:int = jamClock
        var oldLineupClock:int = lineupClock
        officialTimeout = false
        if (period == Period.OVERTIME) {
          if (jamClock) {
            periodClock = 0
            _jamClock = 0
          }
          else if (periodClock) {
            _jamClock = periodClock
            _lineupClock = 0
          }
          else if (homeScore == visitorScore) {
            periodClock = minutes(2)
            _lineupClock = minutes(1)
          }
          else
            period = Period.FINAL
        }
        else {
          if (periodClock) {
            if (_lineupClock || !periodClockRunning) {
              jam += 1
              jamClock = minutes(2)
              _lineupClock = 0
            }
            else {
              _jamClock = 0
              if (periodClock < seconds(30))
                _lineupClock = periodClock
              else
                lineupClock = seconds(30)
            }
          }
          else {
            if (period == 2 && homeScore == visitorScore)
              period = Period.OVERTIME
            else
              period = -period + (period <= 0)
            if (period == Period.OVERTIME) {
              periodClock = minutes(2)
              _lineupClock = minutes(1)
            }
            else {
              jam = 0
              if (period > 0) {
                periodClock = minutes(30)
                intermissionClock = 0
              }
              else if (period == Period.INTERMISSION)
                intermissionClock = intermissionLength
            }
          }
        }
        periodClockRunning = Boolean(jamClock) || Boolean(lineupClock)
        clockChanged('jamClock', oldJamClock)
        clockChanged('lineupClock', oldLineupClock)
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
      var fudge:int = periodClock % 1000
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
        if (period == Period.OVERTIME) {
          if (_lineupClock) {
            _lineupClock = Math.max(_lineupClock - elapsed, 0)
            clockChanged('lineupClock', oldLineupClock)
          }
          else if (_jamClock) {
            if (periodClock)
              periodClock = Math.max(periodClock - elapsed, 0)
            _jamClock = Math.max(_jamClock - elapsed, 0)
            clockChanged('jamClock', oldJamClock)
          }
        }
        else if (period > 0) {
          if (periodClock && periodClockRunning && !timeoutClock)
            periodClock = Math.max(periodClock - elapsed, 0)
          if (timeoutClock)
            timeoutClock = Math.max(timeoutClock - elapsed, 0)
          else if (_lineupClock) {
            _lineupClock = Math.max(_lineupClock - elapsed, 0)
            if (!_lineupClock)
              periodClockRunning = false
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
