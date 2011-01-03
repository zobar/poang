package poang {
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.utils.getTimer
  import mx.events.FlexEvent
  import mx.events.PropertyChangeEvent

  public class Bout extends AbstractLibraryRuleset {
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
        _leadJammer = null
    }
    protected var _leadJammer:String

    override internal function set library(value:Library):void {
      super.library = value
      library.bout = this
    }

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
    public function get period():int {
      return _period
    }
    public function set period(value:int):void {
      _period = value
      if (period > 0)
        lastPeriod = period
    }
    protected var _period:int

    [Bindable]
    public function get periodClock():int {
      return _periodClock
    }
    public function set periodClock(value:int):void {
      _periodClock = fudge(value)
    }
    protected var _periodClock:int

    protected var periodClockRunning:Boolean

    override public function get ruleset():IRuleset {
      return library.preferences
    }

    [Bindable]
    public var timeoutClock:int

    [Bindable]
    public function get name():String {
      return getString('name', 'Untitled Bout')
    }
    public function set name(value:String):void {
      setString('name', value, 'Untitled Bout')
    }

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
      return getObject(Team, 'homeTeam')
    }
    public function set homeTeam(value:Team):void {
      setObject('homeTeam', value)
    }

    [Bindable]
    public function get homeTimeouts():int {
      return _homeTimeouts
    }
    public function set homeTimeouts(value:int):void {
      _homeTimeouts = Math.max(value, 0)
    }
    protected var _homeTimeouts:int

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
      return getObject(Team, 'visitorTeam')
    }
    public function set visitorTeam(value:Team):void {
      setObject('visitorTeam', value)
    }

    [Bindable]
    public function get visitorTimeouts():int {
      return _visitorTimeouts
    }
    public function set visitorTimeouts(value:int):void {
      _visitorTimeouts = Math.max(value, 0)
    }
    protected var _visitorTimeouts:int

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
      var app:Poang = Poang.app
      var preferences:Preferences = app.preferences
      intermissionClock = 0
      _jamClock = 0
      lastPeriod = 0
      leadJammer = null
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
            if (_lineupClock || timeoutClock ||
                (_periodClock && !periodClockRunning)) {
              // Start next jam
              jam += 1
              jamClock = jamLength
              _lineupClock = 0
              timeoutClock = 0
              homeJamScore = 0
              visitorJamScore = 0
            }
            else {
              // End Jam / Start lineup
              homeTeam.jammer = visitorTeam.jammer = null
              _jamClock = 0
              leadJammer = null
              if (_periodClock < lineupLength)
                _lineupClock = _periodClock
              else
                lineupClock = lineupLength
            }
          }
          else {
            homeJamScore = 0
            visitorJamScore = 0
            if (period == periods) {
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
                _periodClock = periodLength
                intermissionClock = 0
                if (period == 1 || timeoutsPer == Timeout.PER_PERIOD)
                  homeTimeouts = visitorTimeouts = timeouts
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
        Poang.app.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
        propertiesWindow.addEventListener(FlexEvent.CREATION_COMPLETE,
            onPropertiesWindowCreationComplete)
        propertiesWindow.bout = this
        propertiesWindow.open()
        propertiesWindow.setFocus()
      }
    }

    public function editTeam(team:Team):void {
      var index:int
      if (team == homeTeam)
        index = 1
      else if (team == visitorTeam)
        index = 2
      if (index) {
        editProperties()
        propertiesWindow.tabs.selectedIndex = index
      }
    }

    public function takeTimeout(team:String):void {
      if (period > 0 && (lineupClock || !periodClockRunning)) {
        if ((team == Team.HOME && homeTimeouts > 0) ||
            (team == Team.VISITOR && visitorTimeouts > 0)) {
          var oldLineupClock:int = lineupClock
          if (team == Team.HOME)
            --homeTimeouts
          else
            --visitorTimeouts
          _lineupClock = lineupLength
          periodClockRunning = false
          timeoutClock = timeoutLength
          clockChanged('lineupClock', oldLineupClock)
        }
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
          if (_periodClock && periodClockRunning) {
            _periodClock = Math.max(_periodClock - elapsed, 0)
            clockChanged('periodClock', oldPeriodClock)
          }
          if (timeoutClock)
            timeoutClock = Math.max(timeoutClock - elapsed, 0)
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

    protected function
        onPropertiesWindowCreationComplete(event:FlexEvent):void {
      event.currentTarget.removeEventListener(FlexEvent.CREATION_COMPLETE,
          onPropertiesWindowCreationComplete)
      Poang.app.addEventListener(Event.ENTER_FRAME, onEnterFrame)
    }
  }
}
