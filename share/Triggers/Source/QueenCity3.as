package {
  import flash.display.Bitmap
  import flash.display.DisplayObject
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.display.MovieClip
  import flash.events.IOErrorEvent
  import flash.net.URLRequest
  import flash.text.TextField

  public class QueenCity3 extends MovieClip {
    public namespace compat = 'urn:QueenCity3:compat'

    public const JAM_CLOCK:String     = 'Jam'
    public const LINEUP_CLOCK:String  = 'Lineup'
    public const TIMEOUT_CLOCK:String = 'Timeout'

    public const HOME_TEAM:String    = 'Home'
    public const VISITOR_TEAM:String = 'Visitor'

    public var auxClock:String

    private var startTime:Number

    compat var homeLogoURL:String
    compat var homePreviousScore:int
    compat var scoreboard:*
    compat var visitorLogoURL:String
    compat var visitorPreviousScore:int
    compat var watchers:Array

    public function get auxClockField():TextField {
      return _auxClockField
    }
    public function set auxClockField(value:TextField):void {
      if (value != _auxClockField) {
        _auxClockField = value
        updateAuxClock()
      }
    }
    protected var _auxClockField:TextField

    public function get auxClockLabel():TextField {
      return _auxClockLabel
    }
    public function set auxClockLabel(value:TextField):void {
      if (value != _auxClockLabel) {
        _auxClockLabel = value
        updateAuxClock()
      }
    }
    protected var _auxClockLabel:TextField

    public function get homeJammerName():String {
      return _homeJammerName
    }
    public function set homeJammerName(value:String):void {
      if (value != _homeJammerName) {
        _homeJammerName = value
        updateHomeJammerName()
      }
    }
    protected var _homeJammerName:String

    public function get homeJammerNameField():TextField {
      return _homeJammerNameField
    }
    public function set homeJammerNameField(value:TextField):void {
      if (value != _homeJammerNameField) {
        _homeJammerNameField = value
        updateHomeJammerName()
      }
    }
    protected var _homeJammerNameField:TextField

    public function get homeJammerNumber():String {
      return _homeJammerNumber
    }
    public function set homeJammerNumber(value:String):void {
      if (value != _homeJammerNumber) {
        _homeJammerNumber = value
        updateHomeJammerNumber()
      }
    }
    protected var _homeJammerNumber:String

    public function get homeJammerNumberField():TextField {
      return _homeJammerNumberField
    }
    public function set homeJammerNumberField(value:TextField):void {
      if (value != _homeJammerNumberField) {
        _homeJammerNumberField = value
        updateHomeJammerNumber()
      }
    }
    protected var _homeJammerNumberField:TextField

    public function get homeJamScore():int {
      return _homeJamScore
    }
    public function set homeJamScore(value:int):void {
      if (value != _homeJamScore) {
        _homeJamScore = value
        updateHomeJamScore()
      }
    }
    protected var _homeJamScore:int

    public function get homeJamScoreField():TextField {
      return _homeJamScoreField
    }
    public function set homeJamScoreField(value:TextField):void {
      if (value != _homeJamScoreField) {
        _homeJamScoreField = value
        updateHomeJamScore()
      }
    }
    protected var _homeJamScoreField:TextField

    public function get homeLeadJammerIndicator():MovieClip {
      return _homeLeadJammerIndicator
    }
    public function set homeLeadJammerIndicator(value:MovieClip):void {
      if (value != _homeLeadJammerIndicator) {
        _homeLeadJammerIndicator = value
        updateHomeLeadJammer()
      }
    }
    protected var _homeLeadJammerIndicator:MovieClip

    public function get homeLogo():DisplayObject {
      return _homeLogo
    }
    public function set homeLogo(value:DisplayObject):void {
      if (value != _homeLogo) {
        _homeLogo = value
        updateHomeName()
      }
    }
    protected var _homeLogo:DisplayObject

    public function get homeLogoPlaceholder():Placeholder {
      return _homeLogoPlaceholder
    }
    public function set homeLogoPlaceholder(value:Placeholder):void {
      if (value != _homeLogoPlaceholder) {
        _homeLogoPlaceholder = value
        updateHomeName()
      }
    }
    protected var _homeLogoPlaceholder:Placeholder

    public function get homeName():String {
      return _homeName
    }
    public function set homeName(value:String):void {
      _homeName = value
      updateHomeName()
    }
    public var _homeName:String

    public function get homeNameField():TextField {
      return _homeNameField
    }
    public function set homeNameField(value:TextField):void {
      _homeNameField = value
      updateHomeName()
    }
    public var _homeNameField:TextField

    public function get homeScore():int {
      return _homeScore
    }
    public function set homeScore(value:int):void {
      if (value != _homeScore) {
        _homeScore = value
        updateHomeScore()
      }
    }
    protected var _homeScore:int

    public function get homeScoreField():TextField {
      return _homeScoreField
    }
    public function set homeScoreField(value:TextField):void {
      if (value != _homeScoreField) {
        _homeScoreField = value
        updateHomeScore()
      }
    }
    protected var _homeScoreField:TextField

    public function get jam():int {
      return _jam
    }
    public function set jam(value:int):void {
      if (value != _jam) {
        _jam = value
        updateJam()
      }
    }
    protected var _jam:int

    public function get jamField():TextField {
      return _jamField
    }
    public function set jamField(value:TextField):void {
      if (value != _jamField) {
        _jamField = value
        updateJam()
      }
    }
    protected var _jamField:TextField
 
    public function get jamClock():int {
      return _jamClock
    }
    public function set jamClock(value:int):void {
      if (value != _jamClock) {
        _jamClock = value
        updateAuxClock()
      }
    }
    protected var _jamClock:int

    public function get leadJammer():String {
      return _leadJammer
    }
    public function set leadJammer(value:String):void {
      _leadJammer = value
      updateHomeLeadJammer()
      updateVisitorLeadJammer()
    }
    protected var _leadJammer:String
 
    public function get lineupClock():int {
      return _lineupClock
    }
    public function set lineupClock(value:int):void {
      if (value != _lineupClock) {
        _lineupClock = value
        updateAuxClock()
      }
    }
    protected var _lineupClock:int

    public function get period():int {
      return _period
    }
    public function set period(value:int):void {
      if (value != _period) {
        _period = value
        updatePeriod()
      }
    }
    protected var _period:int

    public function get periodField():TextField {
      return _periodField
    }
    public function set periodField(value:TextField):void {
      if (value != _periodField) {
        _periodField = value
        updatePeriod()
      }
    }
    protected var _periodField:TextField

    public function get periodClock():Number {
      return _periodClock
    }
    public function set periodClock(value:Number):void {
      if (value != _periodClock) {
        _periodClock = value
        updatePeriodClock()
      }
    }
    protected var _periodClock:Number

    public function get periodClockField():TextField {
      return _periodClockField
    }
    public function set periodClockField(value:TextField):void {
      if (value != _periodClockField) {
        _periodClockField = value
        updatePeriodClock()
      }
    }
    protected var _periodClockField:TextField
 
    public function get timeoutClock():int {
      return _timeoutClock
    }
    public function set timeoutClock(value:int):void {
      if (value != _timeoutClock) {
        _timeoutClock = value
        updateAuxClock()
      }
    }
    protected var _timeoutClock:int

    public function get visitorJammerName():String {
      return _visitorJammerName
    }
    public function set visitorJammerName(value:String):void {
      if (value != _visitorJammerName) {
        _visitorJammerName = value
        updateVisitorJammerName()
      }
    }
    protected var _visitorJammerName:String

    public function get visitorJammerNameField():TextField {
      return _visitorJammerNameField
    }
    public function set visitorJammerNameField(value:TextField):void {
      if (value != _visitorJammerNameField) {
        _visitorJammerNameField = value
        updateVisitorJammerName()
      }
    }
    protected var _visitorJammerNameField:TextField

    public function get visitorJammerNumber():String {
      return _visitorJammerNumber
    }
    public function set visitorJammerNumber(value:String):void {
      if (value != _visitorJammerNumber) {
        _visitorJammerNumber = value
        updateVisitorJammerNumber()
      }
    }
    protected var _visitorJammerNumber:String

    public function get visitorJammerNumberField():TextField {
      return _visitorJammerNumberField
    }
    public function set visitorJammerNumberField(value:TextField):void {
      if (value != _visitorJammerNumberField) {
        _visitorJammerNumberField = value
        updateVisitorJammerNumber()
      }
    }
    protected var _visitorJammerNumberField:TextField

    public function get visitorJamScore():int {
      return _visitorJamScore
    }
    public function set visitorJamScore(value:int):void {
      if (value != _visitorJamScore) {
        _visitorJamScore = value
        updateVisitorJamScore()
      }
    }
    protected var _visitorJamScore:int

    public function get visitorJamScoreField():TextField {
      return _visitorJamScoreField
    }
    public function set visitorJamScoreField(value:TextField):void {
      if (value != _visitorJamScoreField) {
        _visitorJamScoreField = value
        updateVisitorJamScore()
      }
    }
    protected var _visitorJamScoreField:TextField

    public function get visitorLeadJammerIndicator():MovieClip {
      return _visitorLeadJammerIndicator
    }
    public function set visitorLeadJammerIndicator(value:MovieClip):void {
      if (value != _visitorLeadJammerIndicator) {
        _visitorLeadJammerIndicator = value
        updateVisitorLeadJammer()
      }
    }
    protected var _visitorLeadJammerIndicator:MovieClip

    public function get visitorLogo():DisplayObject {
      return _visitorLogo
    }
    public function set visitorLogo(value:DisplayObject):void {
      if (value != _visitorLogo) {
        _visitorLogo = value
        updateVisitorName()
      }
    }
    protected var _visitorLogo:DisplayObject

    public function get visitorLogoPlaceholder():Placeholder {
      return _visitorLogoPlaceholder
    }
    public function set visitorLogoPlaceholder(value:Placeholder):void {
      if (value != _visitorLogoPlaceholder) {
        _visitorLogoPlaceholder = value
        updateVisitorName()
      }
    }
    protected var _visitorLogoPlaceholder:Placeholder

    public function get visitorName():String {
      return _visitorName
    }
    public function set visitorName(value:String):void {
      _visitorName = value
      updateVisitorName()
    }
    public var _visitorName:String

    public function get visitorNameField():TextField {
      return _visitorNameField
    }
    public function set visitorNameField(value:TextField):void {
      _visitorNameField = value
      updateVisitorName()
    }
    public var _visitorNameField:TextField

    public function get visitorScore():int {
      return _visitorScore
    }
    public function set visitorScore(value:int):void {
      if (value != _visitorScore) {
        _visitorScore = value
        updateVisitorScore()
      }
    }
    protected var _visitorScore:int

    public function get visitorScoreField():TextField {
      return _visitorScoreField
    }
    public function set visitorScoreField(value:TextField):void {
      if (value != _visitorScoreField) {
        _visitorScoreField = value
        updateVisitorScore()
      }
    }
    protected var _visitorScoreField:TextField

    public function QueenCity3() {
      stop()
      addEventListener(Event.REMOVED_FROM_STAGE, compat::onRemovedFromStage)
    }

    public function qcrgInitScoreboard(scoreboard:*):void {
      startTime = scoreboard.periodClock
      compat::watchers = []
      compat::scoreboard = scoreboard
      compat::watchers.push(scoreboard.bindProperty(this, 'homeJammerName',      scoreboard, ['home',    'jammer', 'name'         ]))
      compat::watchers.push(scoreboard.bindProperty(this, 'homeJammerNumber',    scoreboard, ['home',    'jammer', 'number'       ]))
      compat::watchers.push(scoreboard.bindSetter  (compat::setHomeLogo,         scoreboard, ['home',    'logo',   'file',   'url']))
      compat::watchers.push(scoreboard.bindProperty(this, 'homeName',            scoreboard, ['home',    'team'                   ]))
      compat::watchers.push(scoreboard.bindSetter  (compat::setHomeScore,        scoreboard, ['home',    'score'                  ]))
      compat::watchers.push(scoreboard.bindProperty(this, 'jamClock',            scoreboard,  'jamClock'                           ))
      compat::watchers.push(scoreboard.bindProperty(this, 'leadJammer',          scoreboard,  'leadJammer'                         ))
      compat::watchers.push(scoreboard.bindProperty(this, 'lineupClock',         scoreboard,  'breakClock'                         ))
      compat::watchers.push(scoreboard.bindProperty(this, 'period',              scoreboard,  'period'                             ))
      compat::watchers.push(scoreboard.bindProperty(this, 'periodClock',         scoreboard,  'periodClock'                        ))
      compat::watchers.push(scoreboard.bindProperty(this, 'timeoutClock',        scoreboard,  'timeoutClock'                       ))
      compat::watchers.push(scoreboard.bindProperty(this, 'visitorJammerName',   scoreboard, ['visitor', 'jammer', 'name'         ]))
      compat::watchers.push(scoreboard.bindProperty(this, 'visitorJammerNumber', scoreboard, ['visitor', 'jammer', 'number'       ]))
      compat::watchers.push(scoreboard.bindSetter  (compat::setVisitorLogo,      scoreboard, ['visitor', 'logo',   'file',   'url']))
      compat::watchers.push(scoreboard.bindProperty(this, 'visitorName',         scoreboard, ['visitor', 'team'                   ]))
      compat::watchers.push(scoreboard.bindSetter  (compat::setVisitorScore,     scoreboard, ['visitor', 'score'                  ]))
      compat::watchers.push(scoreboard.bindSetter  (compat::setJam,              scoreboard,  'jam'                                ))
    }

    compat function onRemovedFromStage(event:Event):void {
      removeEventListener(Event.REMOVED_FROM_STAGE, compat::onRemovedFromStage)
      if (compat::watchers) {
        for (var i:int = 0; i < compat::watchers.length; ++i)
          compat::watchers[i].unwatch()
      }
      compat::watchers = null
      compat::scoreboard = null
    }

    compat function setHomeLogo(url:String):void {
      compat::homeLogoURL = url
      updateHomeName()
    }

    compat function onHomeLogoLoaderComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, compat::onHomeLogoLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, compat::onHomeLogoLoaderIOError)
    }

    compat function onHomeLogoLoaderIOError(event:IOErrorEvent):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, compat::onHomeLogoLoaderComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, compat::onHomeLogoLoaderIOError)
      homeLogo = null
    }

    compat function setHomeScore(value:int):void {
      homeScore = value
      homeJamScore = Math.max(0, homeScore - compat::homePreviousScore)
    }

    compat function setJam(value:int):void {
      jam = value
      homeJamScore = 0
      visitorJamScore = 0
      compat::homePreviousScore = homeScore
      compat::visitorPreviousScore = visitorScore
    }

    compat function setVisitorLogo(url:String):void {
      compat::visitorLogoURL = url
      updateVisitorName()
    }

    compat function setVisitorScore(value:int):void {
      visitorScore = value
      visitorJamScore = Math.max(0, visitorScore - compat::visitorPreviousScore)
    }

    protected function formatTime(time:Number, field:TextField):void {
      if (field) {
        var result:String
        var roundUp:int
        var seconds:int
        time = time / 1000
        roundUp = time
        seconds = roundUp % 60
        if (roundUp >= 60) {
          var minutes:int = roundUp / 60
          if (seconds >= 10)
            result = minutes + ':' + seconds
          else if (seconds > 0)
            result = minutes + ':0' + seconds
          else
            result = minutes + ':00'
        }
        else {
          var tenths:int = (time * 10) % 10
          if (seconds >= 10)
            result = ':' + seconds + '.' + tenths
          else if (seconds > 0)
            result = ':0' + seconds + '.' + tenths
          else
            result = ':00.' + tenths
        }
        if (field.text != result)
          field.text = result
      }
    }

    protected function updateAuxClock():void {
      var label:String
      var time:Number
      if (jamClock) {
        auxClock = JAM_CLOCK
        time = jamClock
      }
      else if (timeoutClock) {
        auxClock = TIMEOUT_CLOCK
        time = timeoutClock
      }
      else if (lineupClock) {
        auxClock = LINEUP_CLOCK
        time = lineupClock
      }
      else
        time = 0
      label = auxClock
      if (auxClock) {
        formatTime(time, auxClockField)
        if (auxClockLabel && auxClockLabel.text != label)
          auxClockLabel.text = label
      }
      else {
        if (auxClockField && auxClockField.text)
          auxClockField.text = ''
        if (auxClockLabel && auxClockLabel.text)
          auxClockLabel.text = ''
      }
    }

    protected function updateHomeJammerName():void {
      var name:String = homeJammerName ? homeJammerName : ''
      if (homeJammerNameField && homeJammerNameField.text != name)
        homeJammerNameField.text = name
    }

    protected function updateHomeJammerNumber():void {
      var number:String = homeJammerNumber ? homeJammerNumber : ''
      if (homeJammerNumberField && homeJammerNumberField.text != number)
        homeJammerNumberField.text = number
    }

    protected function updateHomeJamScore():void {
      if (homeJamScoreField) {
        if (homeJamScore) {
          var score:String = String(homeJamScore)
          if (homeJamScoreField.text != score)
            homeJamScoreField.text = score
        }
        else if (homeJamScoreField.text)
          homeJamScoreField.text = ''
      }
    }

    protected function updateHomeLeadJammer():void {
      if (homeLeadJammerIndicator) {
        homeLeadJammerIndicator.visible = (leadJammer == HOME_TEAM)
        if (homeLeadJammerIndicator.visible)
          homeLeadJammerIndicator.gotoAndPlay(1)
        else
          homeLeadJammerIndicator.stop()
      }
    }

    protected function updateHomeName():void {
      if (compat::homeLogoURL && homeLogoPlaceholder) {
        homeLogoPlaceholder.source = compat::homeLogoURL
        homeLogoPlaceholder.visible = true
        if (homeNameField)
          homeNameField.visible = false
      }
      else if (homeNameField) {
        if (homeName) {
          if (homeNameField.text != homeName)
            homeNameField.text = homeName
        }
        else if (homeNameField.text != HOME_TEAM)
          homeNameField.text = HOME_TEAM
        homeNameField.visible = true
        if (homeLogoPlaceholder)
          homeLogoPlaceholder.visible = false
      }
    }

    protected function updateHomeScore():void {
      if (homeScoreField) {
        var score:String = String(homeScore)
        if (homeScoreField.text != score)
          homeScoreField.text = String(homeScore)
      }
    }

    protected function updateJam():void {
      if (jamField) {
        var j:String = String(jam)
        if (jamField.text != j)
          jamField.text = j
      }
    }

    protected function updatePeriod():void {
      if (periodField) {
        var p:String = String(period)
        if (periodField.text != p)
          periodField.text = p
      }
    }

    protected function updatePeriodClock():void {
      formatTime(periodClock, periodClockField)
    }

    protected function updateVisitorJammerName():void {
      var name:String = visitorJammerName ? visitorJammerName : ''
      if (visitorJammerNameField && visitorJammerNameField.text != name)
        visitorJammerNameField.text = name
    }

    protected function updateVisitorJammerNumber():void {
      var number:String = visitorJammerNumber ? visitorJammerNumber : ''
      if (visitorJammerNumberField && visitorJammerNumberField.text != number)
        visitorJammerNumberField.text = number
    }

    protected function updateVisitorJamScore():void {
      if (visitorJamScoreField) {
        if (visitorJamScore) {
          var score:String = String(visitorJamScore)
          if (visitorJamScoreField.text != score)
            visitorJamScoreField.text = score
        }
        else if (visitorJamScoreField.text)
          visitorJamScoreField.text = ''
      }
    }

    protected function updateVisitorLeadJammer():void {
      if (visitorLeadJammerIndicator) {
        visitorLeadJammerIndicator.visible = (leadJammer == VISITOR_TEAM)
        if (visitorLeadJammerIndicator.visible)
          visitorLeadJammerIndicator.gotoAndPlay(1)
        else
          visitorLeadJammerIndicator.stop()
      }
    }

    protected function updateVisitorName():void {
      if (compat::visitorLogoURL && visitorLogoPlaceholder) {
        visitorLogoPlaceholder.source = compat::visitorLogoURL
        visitorLogoPlaceholder.visible = true
        if (visitorNameField)
          visitorNameField.visible = false
      }
      else if (visitorNameField) {
        if (visitorName) {
          if (visitorNameField.text != visitorName)
            visitorNameField.text = visitorName
        }
        else if (visitorNameField.text != VISITOR_TEAM)
          visitorNameField.text = VISITOR_TEAM
        visitorNameField.visible = true
        if (visitorLogoPlaceholder)
          visitorLogoPlaceholder.visible = false
      }
    }

    protected function updateVisitorScore():void {
      if (visitorScoreField) {
        var score:String = String(visitorScore)
        if (visitorScoreField.text != score)
          visitorScoreField.text = String(visitorScore)
      }
    }
  }
}
