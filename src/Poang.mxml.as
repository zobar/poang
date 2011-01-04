import dpk.GithubUpdater
import dpk.MenuItemBase
import dpk.NativeMenuEvent
import dpk.minutes
import dpk.seconds
import dpk.UpdateEvent
import dpk.WindowHelper
import flash.events.FocusEvent
import flash.filesystem.File
import mx.binding.utils.BindingUtils
import mx.collections.ArrayCollection
import mx.collections.IList
import mx.events.FlexEvent
import mx.events.PropertyChangeEvent
import mx.managers.IFocusManagerComponent
import mx.managers.ISystemManager
import poang.*
import spark.events.IndexChangeEvent
import spark.events.TextOperationEvent

[Bindable]
public var periods:ArrayCollection = new ArrayCollection([0, 1, -1, 2, -2, -3]);

public static function get app():Poang {
  return _app
}
protected static var _app:Poang

protected static function formatTime(time:int):String {
  return poang.formatTime(time, true)
}

[Bindable]
public function get bout():Bout {
  return _bout
}
public function set bout(value:Bout):void {
  if (bout) {
    if (bout.homeTeam) {
      bout.homeTeam.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
          onHomeTeamPropertyChange)
    }
    if (bout.visitorTeam) {
      bout.visitorTeam.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
          onVisitorTeamPropertyChange)
    }
    bout.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
        onBoutPropertyChange)
  }
  _bout = value
  if (bout) {
    var focused:IFocusManagerComponent = focusManager.getFocus()
    if (intermissionClockField != focused)
      intermissionClockField.text = formatTime(bout.intermissionClock)
    if (jamClockField != focused)
      jamClockField.text = formatTime(bout.jamClock)
    if (jamField != focused)
      jamField.text = String(bout.jam)
    if (lineupClockField != focused)
      lineupClockField.text = formatTime(bout.lineupClock)
    if (periodClockField != focused)
      periodClockField.text = formatTime(bout.periodClock)
    if (periodList != focused)
      periodList.selectedItem = bout.period
    if (timeoutClockField != focused)
      timeoutClockField.text = formatTime(bout.timeoutClock)
    if (displayGroup)
      updateDisplay(displayGroup.content)
    updatePeriods()
    bout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
        onBoutPropertyChange)
    if (bout.homeTeam) {
      bout.homeTeam.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
          onHomeTeamPropertyChange)
    }
    if (bout.visitorTeam) {
      bout.visitorTeam.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
          onVisitorTeamPropertyChange)
    }
  }
}
protected var _bout:Bout

protected var commitField:Boolean

[Bindable]
public var displayGroup:DisplayGroup

protected var displays:ArrayCollection

protected var helper:WindowHelper

public function get library():Library {
  return _library
}
public function set library(value:Library):void {
  _library = value
}
protected var _library:Library

public function get preferences():Preferences {
  return library.preferences
}

public function get preferencesWindow():PreferencesWindow {
  return _preferencesWindow
}
public function set preferencesWindow(value:PreferencesWindow):void {
  if (preferencesWindow)
    preferencesWindow.removeEventListener(Event.CLOSE, onPreferencesWindowClose)
  _preferencesWindow = value
  if (preferencesWindow)
    preferencesWindow.addEventListener(Event.CLOSE, onPreferencesWindowClose)
}
protected var _preferencesWindow:PreferencesWindow

[Bindable]
public function get screens():Array {
  if (!_screens) {
    _screens = Screen.screens
  }
  return _screens
}
public function set screens(value:Array):void {
  _screens = value
}
protected var _screens:Array

public function get updateCompleteWindow():UpdateCompleteWindow {
  return _updateCompleteWindow
}
public function set updateCompleteWindow(value:UpdateCompleteWindow):void {
  if (updateCompleteWindow) {
    updateCompleteWindow.removeEventListener(Event.CLOSE,
        onUpdateCompleteWindowClose)
  }
  _updateCompleteWindow = value
  if (updateCompleteWindow) {
    updateCompleteWindow.addEventListener(Event.CLOSE,
        onUpdateCompleteWindowClose)
  }
}
protected var _updateCompleteWindow:UpdateCompleteWindow

public function get updateNotificationWindow():UpdateNotificationWindow {
  return _updateNotificationWindow
}
public function set
    updateNotificationWindow(value:UpdateNotificationWindow):void {
  if (updateNotificationWindow) {
    updateNotificationWindow.removeEventListener(Event.CLOSE,
        onUpdateNotificationWindowClose)
  }
  _updateNotificationWindow = value
  if (updateNotificationWindow) {
    updateNotificationWindow.addEventListener(Event.CLOSE,
        onUpdateNotificationWindowClose)
  }
}
protected var _updateNotificationWindow:UpdateNotificationWindow

public function get updater():GithubUpdater {
  return _updater
}
public function set updater(value:GithubUpdater):void {
  if (updater) {
    updater.removeEventListener(Event.COMPLETE, onUpdateComplete)
    updater.removeEventListener(UpdateEvent.UPDATE_AVAILABLE, onUpdateAvailable)
  }
  _updater = value
  if (updater) {
    updater.addEventListener(Event.COMPLETE, onUpdateComplete)
    updater.addEventListener(UpdateEvent.UPDATE_AVAILABLE, onUpdateAvailable)
  }
}
protected var _updater:GithubUpdater

protected var updates:Object
protected var windowHelper:WindowHelper

public function displayForScreen(screen:Screen):DisplayWindow {
  if (displays) {
    var bounds:Rectangle = screen.bounds
    for (var i:int = 0; i < displays.length; ++i) {
      var display:DisplayWindow = DisplayWindow(displays.getItemAt(i))
      if (bounds.equals(display.displayScreen.bounds))
        return display
    }
  }
  return null
}

public function getScreenIndex(screen:Screen):int {
  var bounds:Rectangle = screen.bounds
  for (var i:int = 0; i < screens.length; ++i) {
    var s:Screen = screens[i]
    if (bounds.equals(s.bounds))
      return i
  }
  return -1
}

public function screenToString(screen:Screen):String {
  var bounds:Rectangle = screen.bounds
  if (bounds.equals(Screen.mainScreen.bounds))
    return 'Main Screen'
  return 'Screen ' + (getScreenIndex(screen) + 1)
}

public function updateScreens():void {
  screens = Screen.screens
  callLater(checkNewScreens)
}

protected function checkNewScreens():void {
  for each (var screenNumber:int in preferences.displayScreens) {
    if (screens.length > screenNumber) {
      var screen:Screen = screens[screenNumber]
      if (!displayForScreen(screen))
        openDisplay(screen)
    }
  }
}

protected function fieldFocusOut(event:FocusEvent, property:String,
    parse:Function, format:*):void {
  var field:TextInput = TextInput(event.currentTarget)
  var value:Number = NaN
  if (commitField)
    value = parse(field.text)
  if (isNaN(value))
    field.text = format(bout[property])
  else
    bout[property] = value
}

protected function menuItemForScreen(screen:Screen):MenuItem {
  var bounds:Rectangle = screen.bounds
  var menuItems:IList = screenMenu.children
  for (var i:int = 0; i < menuItems.length; ++i) {
    var menuItem:MenuItem = MenuItem(menuItems.getItemAt(i))
    var screen:Screen = Screen(menuItem.data)
    if (bounds.equals(screen.bounds))
      return menuItem
  }
  return null
}

protected function onApplicationComplete(event:FlexEvent):void {
  var loader:Loader = new Loader()
  loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDisplayLoaderComplete)
  loader.load(new URLRequest('Framsta.swf'))
  stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true)
  // Linux glitch: doesn't adjust layout after adding menu bar.  On other
  // platforms, these should already be equal.
  height = stage.stageHeight
}

protected function onBoutPropertyChange(event:PropertyChangeEvent):void {
  var focused:IFocusManagerComponent = focusManager.getFocus()
  var oldValue:* = event.oldValue
  var property:Object = event.property
  var value:* = event.newValue
  switch (property) {
    case 'intermissionClock':
      if (intermissionClockField != focused)
        intermissionClockField.text = formatTime(value)
      break
    case 'jam':
      if (jamField != focused)
        jamField.text = value
      break
    case 'jamClock':
      if (jamClockField != focused)
        jamClockField.text = formatTime(value)
      break
    case 'lineupClock':
      if (lineupClockField != focused)
        lineupClockField.text = formatTime(value)
      break
    case 'period':
      if (periodList != focused)
        periodList.selectedItem = value
      break
    case 'periodClock':
      if (periodClockField != focused)
        periodClockField.text = formatTime(value)
      break
    case 'periods':
      updatePeriods()
      break
    case 'timeoutClock':
      if (timeoutClockField != focused)
        timeoutClockField.text = formatTime(value)
      break

    case 'homeTeam':
      if (oldValue) {
        oldValue.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
            onHomeTeamPropertyChange)
      }
      if (value) {
        value.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
            onHomeTeamPropertyChange)
      }
      updateTeamDisplay('home')
      break

    case 'visitorTeam':
      if (oldValue) {
        oldValue.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
            onVisitorTeamPropertyChange)
      }
      if (value) {
        value.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
            onVisitorTeamPropertyChange)
      }
      updateTeamDisplay('visitor')
      break
  }
  if (!updates)
    updates = {}
  updates[property] = value
}

protected function onClose(event:Event):void {
  exit()
}

protected function onCloseSelect(event:NativeMenuEvent):void {
  var activeNativeWindow:NativeWindow =
      NativeApplication.nativeApplication.activeWindow
  if (activeNativeWindow)
    ISystemManager(activeNativeWindow.stage.getChildAt(0)).document.close()
}

protected function onDisplayClose(event:Event):void {
  var display:DisplayWindow = DisplayWindow(event.currentTarget)
  var bounds:Rectangle = display.displayScreen.bounds
  var index:int = displays.getItemIndex(display)
  var menuItem:MenuItem = menuItemForScreen(display.displayScreen)
  display.removeEventListener(Event.CLOSE, onDisplayClose)
  if (index != -1)
    displays.removeItemAt(index)
  if (menuItem)
    menuItem.checked = false
}

protected function onDisplayLoaderComplete(event:Event):void {
  var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
  var loader:Loader = loaderInfo.loader
  var content:DisplayObject = loader.content
  updateDisplay(content)
  displayGroup.setContent(content, new Rectangle(0, 0, loaderInfo.width,
      loaderInfo.height))
}

protected function onEnterFrame(event:Event):void {
  var content:DisplayObject = displayGroup.content
  if (content && updates && 'update' in content)
    content['update'](updates)
  updates = null
}

protected function onFieldChange(event:TextOperationEvent):void {
  TextInput(event.currentTarget).removeEventListener(TextOperationEvent.CHANGE,
      onFieldChange)
  commitField = true
}

protected function onFieldFocusIn(event:FocusEvent):void {
  var field:TextInput = TextInput(event.currentTarget)
  commitField = false
  field.selectAll()
  field.addEventListener(TextOperationEvent.CHANGE, onFieldChange)
  field.addEventListener(FocusEvent.FOCUS_OUT, onFieldFocusOut)
}

protected function onFieldFocusOut(event:FocusEvent):void {
  var field:TextInput = TextInput(event.currentTarget)
  field.removeEventListener(TextOperationEvent.CHANGE, onFieldChange)
  field.removeEventListener(FocusEvent.FOCUS_OUT, onFieldFocusOut)
}

protected function onInitialize(event:FlexEvent):void {
  displayGroup = new DisplayGroup()
  displays = new ArrayCollection()
  updater = new GithubUpdater('zobar', 'poang', 'dist/update.xml')
  library = new Library()
  library.addEventListener(Event.COMPLETE, onLibraryComplete)
  library.load(File.applicationStorageDirectory.resolvePath('library.xml').url)
}

protected function onIntermissionClockFieldFocusOut(event:FocusEvent):void {
  fieldFocusOut(event, 'intermissionClock', parseTime, formatTime)
}

protected function onJamClockFieldFocusOut(event:FocusEvent):void {
  fieldFocusOut(event, 'jamClock', parseTime, formatTime)
}

protected function onJamFieldFocusOut(event:FocusEvent):void {
  fieldFocusOut(event, 'jam', parseInt, String)
}

protected function onKeyDown(event:KeyboardEvent):void {
  var handled:Boolean = true
  var shiftKey:Boolean = event.shiftKey
  switch (event.keyCode) {
    case Keyboard.ESCAPE:
      commitField = false
      // fall through
    case Keyboard.ENTER:
      setFocus()
      handled = false
      break
    case Keyboard.COMMA:
      bout.visitorTimeouts = Math.max(bout.visitorTimeouts - 1, 0)
      break
    case Keyboard.PERIOD:
      bout.visitorTimeouts = Math.min(bout.visitorTimeouts + 1, bout.timeouts)
      break
    case Keyboard.SLASH:
      bout.takeTimeout(Team.VISITOR)
      break
    case Keyboard.B:
      bout.advance()
      break
    case Keyboard.C:
      bout.homeTimeouts = Math.max(bout.homeTimeouts - 1, 0)
      break
    case Keyboard.G:
      if (bout.jamClock && bout.period > 0)
        bout.leadJammer = Team.HOME
      break
    case Keyboard.H:
      if (bout.jamClock && bout.period > 0)
        bout.leadJammer = Team.NONE
      break
    case Keyboard.J:
      if (bout.jamClock && bout.period > 0)
        bout.leadJammer = Team.VISITOR
      break
    case Keyboard.N:
      bout.officialTimeout = !bout.officialTimeout
      break
    case Keyboard.Q:
      ++bout.homeScore
      if (!shiftKey)
        ++bout.homeJamScore
      break
    case Keyboard.W:
      if (bout.homeScore) {
        --bout.homeScore
        if (bout.homeJamScore && !shiftKey)
          --bout.homeJamScore
      }
      break
    case Keyboard.X:
      bout.homeTimeouts = Math.min(bout.homeTimeouts + 1, bout.timeouts)
      break
    case Keyboard.Z:
      bout.takeTimeout(Team.HOME)
      break
    case Keyboard.LEFTBRACKET:
      if (bout.visitorScore) {
        --bout.visitorScore
        if (bout.visitorJamScore && !shiftKey)
          --bout.visitorJamScore
      }
      break
    case Keyboard.RIGHTBRACKET:
      ++bout.visitorScore
      if (!shiftKey)
        ++bout.visitorJamScore
      break
    default:
      handled = false
  }
  if (handled)
    event.preventDefault()
}

protected function onLibraryComplete(event:Event):void {
  helper = new WindowHelper('main', this, preferences)
  BindingUtils.bindProperty(this, 'bout', library, 'bout')
  if (!library.bout)
    library.newBout()
  updateScreens()
  BindingUtils.bindProperty(updater, 'branch', preferences, 'releaseTrack')
  if (preferences.autoUpdate)
    updater.check()
}

protected function onLineupClockFieldFocusOut(event:FocusEvent):void {
  fieldFocusOut(event, 'lineupClock', parseTime, formatTime)
}

protected function onNewSelect(event:NativeMenuEvent):void {
  library.newBout()
}

protected function onPeriodClockFieldFocusOut(event:FocusEvent):void {
  fieldFocusOut(event, 'periodClock', parseTime, formatTime)
}

protected function onPeriodListChange(event:IndexChangeEvent):void {
  commitField = true
}

protected function onPeriodListFocusIn(event:FocusEvent):void {
  commitField = false
}

protected function onPeriodListFocusOut(event:FocusEvent):void {
  if (commitField)
    bout.period = periodList.selectedItem
  else
    periodList.selectedItem = bout.period
}

protected function onPreferencesSelect(event:NativeMenuEvent):void {
  if (preferencesWindow)
    preferencesWindow.activate()
  else {
    preferencesWindow = new PreferencesWindow()
    preferencesWindow.open()
    preferencesWindow.setFocus()
  }
}

protected function onPreferencesWindowClose(event:Event):void {
  preferencesWindow = null
}

protected function onPreinitialize(event:FlexEvent):void {
  if (!_app)
    _app = this
}

protected function onPreviewResize(event:Event):void {
  var preview:* = event.currentTarget
  trace('RESIZE application=' + width + 'x' + height + ', preview=' + (preview.width - 2) + 'x' + (preview.height - 2))
}

protected function onPropertiesSelect(event:NativeMenuEvent):void {
  bout.editProperties()
}

protected function onQuitSelect(event:NativeMenuEvent):void {
  exit()
}

protected function onRescanSelect(event:NativeMenuEvent):void {
  updateScreens()
}

protected function onScreenSelect(event:NativeMenuEvent):void {
  var menuItem:MenuItem = MenuItem(event.menuItem)
  var screen:Screen = menuItem.data
  var display:DisplayWindow = displayForScreen(screen)
  var displayScreens:Array = preferences.displayScreens || []
  var screenNumber:int = getScreenIndex(screen)
  var i:int = displayScreens.indexOf(screenNumber)
  if (display) {
    display.close()
    if (screenNumber != -1 && i != -1)
      displayScreens.splice(i, 1)
  }
  else {
    openDisplay(screen)
    if (screenNumber != -1 && i == -1)
      displayScreens.push(screenNumber)
  }
  preferences.displayScreens = displayScreens.length ?  displayScreens : null
}

protected function onTimeoutClockFieldFocusOut(event:FocusEvent):void {
  fieldFocusOut(event, 'timeoutClock', parseTime, formatTime)
}

protected function onUpdateAvailable(event:UpdateEvent):void {
  if (updateNotificationWindow)
    updateNotificationWindow.activate()
  else {
    updateNotificationWindow = new UpdateNotificationWindow()
    updateNotificationWindow.open()
  }
}

protected function onUpdateComplete(event:Event):void {
  if (updateCompleteWindow)
    updateCompleteWindow.activate()
  else {
    updateCompleteWindow = new UpdateCompleteWindow()
    updateCompleteWindow.open()
  }
}

protected function onUpdateCompleteWindowClose(event:Event):void {
  updateCompleteWindow = null
}

protected function onUpdateNotificationWindowClose(event:Event):void {
  updateNotificationWindow = null
}

protected function onHomeJammerPropertyChange(event:PropertyChangeEvent):void {
  jammerPropertyChange('home', event.property, event.newValue)
}

protected function onHomeTeamPropertyChange(event:PropertyChangeEvent):void {
  var property:Object = event.property
  var value:* = event.newValue
  if (property == 'jammer') {
    var oldValue:* = event.oldValue
    if (oldValue) {
      oldValue.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
        onHomeJammerPropertyChange)
    }
    if (value) {
      value.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
          onHomeJammerPropertyChange)
    }
  }
  teamPropertyChange('home', event.property, value)
}

protected function
    onVisitorJammerPropertyChange(event:PropertyChangeEvent):void {
  jammerPropertyChange('visitor', event.property, event.newValue)
}

protected function onVisitorTeamPropertyChange(event:PropertyChangeEvent):void {
  var property:Object = event.property
  var value:* = event.newValue
  if (property == 'jammer') {
    var oldValue:* = event.oldValue
    if (oldValue) {
      oldValue.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
        onVisitorJammerPropertyChange)
    }
    if (value) {
      value.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
          onVisitorJammerPropertyChange)
    }
  }
  teamPropertyChange('visitor', event.property, value)
}

protected function jammerPropertyChange(which:String, property:Object,
    value:*):void {
  if (!updates)
    updates = {}
  updates[which + 'Jammer' + property.charAt(0).toUpperCase() +
      property.substring(1)] = value
}

protected function openDisplay(screen:Screen):void {
  var display:DisplayWindow = new DisplayWindow()
  var menuItem:MenuItem = menuItemForScreen(screen)
  display.addEventListener(Event.CLOSE, onDisplayClose)
  display.displayGroup = displayGroup
  display.displayScreen = screen
  display.open()
  displays.addItem(display)
  if (menuItem)
    menuItem.checked = true
}

protected function periodListLabelFunction(value:int):String {
  return Period.toString(value)
}

protected function screenMenuItem(screen:Screen,
    recycle:MenuItemBase):MenuItemBase {
  var bounds:Rectangle = screen.bounds
  var label:String
  var menuItem:MenuItem = recycle as MenuItem
  if (!menuItem)
    menuItem = new MenuItem()
  menuItem.checked = displayForScreen(screen) != null
  menuItem.data = screen
  menuItem.label = screenToString(screen) + ' (' + bounds.width + '×' +
      bounds.height + ')'
  return menuItem
}

protected function teamPropertyChange(which:String, property:Object,
    value:*):void {
  if (!updates)
    updates = {}
  if (property == 'jammer')
    updateJammerDisplay(which, updates)
  else {
    updates[which + property.charAt(0).toUpperCase() + property.substring(1)] =
        value
  }
}

protected function updateDisplay(display:*):void {
  if (bout && display && 'update' in display) {
    var values:Object = {
      intermissionClock: bout.intermissionClock,
      jam:               bout.jam,
      jamClock:          bout.jamClock,
      leadJammer:        bout.leadJammer,
      lineupClock:       bout.lineupClock,
      period:            bout.period,
      periodClock:       bout.periodClock,
      timeoutClock:      bout.timeoutClock,

      homeJamScore:      bout.homeJamScore,
      homeScore:         bout.homeScore,
      homeTimeouts:      bout.homeTimeouts,

      visitorJamScore:   bout.visitorJamScore,
      visitorScore:      bout.visitorScore,
      visitorTimeouts:   bout.visitorTimeouts
    }
    updateTeamDisplay('home', values)
    updateTeamDisplay('visitor', values)
    display.update(values)
  }
}

protected function updateJammerDisplay(which:String, values:Object=null):Object {
  var jammer:Person = bout[which + 'Team'].jammer
  if (jammer) {
    if (!values) {
      if (!updates)
        updates = {}
      values = updates
    }
    values[which + 'JammerImage'] = jammer.image
    values[which + 'JammerName'] = jammer.name
    values[which + 'JammerNumber'] = jammer.number
  }
  else {
    values[which + 'JammerImage'] =
        values[which + 'JammerName'] =
        values[which + 'JammerNumber'] = null
  }
  return values
}

protected function updatePeriods():void {
  var p:Array = [0, 1, -1]
  for (var i:int = 2; i <= bout.periods; ++i)
    p.push(i)
  periods.source = p.concat(-2, -3)
}

protected function updateTeamDisplay(which:String, values:Object=null):Object {
  var team:Team = bout[which + 'Team']
  if (team) {
    if (!values) {
      if (!updates)
        updates = {}
      values = updates
    }
    values[which + 'Image'] = team.image
    values[which + 'Name'] = team.name
  }
  else
    values[which + 'Image'] = values[which + 'Name'] = null
  updateJammerDisplay(which, values)
  return values
}
