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
import qcrg.*
import spark.events.IndexChangeEvent
import spark.events.TextOperationEvent

[Bindable]
public var periods:ArrayCollection = new ArrayCollection([0, 1, -1, 2, -2, -3]);

[Bindable]
public var players:ArrayCollection = new ArrayCollection([
  {number: '16',    name: 'Ace Bandage'           },
  {number: '525',   name: 'Addy Rawl'             },
  {number: '216',   name: 'Alablaster'            },
  {number: '42',    name: 'Alley Oops'            },
  {number: '19',    name: 'Argo'                  },
  {number: '17',    name: 'B-17'                  },
  {number: '40',    name: 'Babe Lincoln'          },
  {number: '613',   name: 'Bash-Full'             },
  {number: '6',     name: 'Bea Aggressive'        },
  {number: '55',    name: 'Beauty School Knockout'},
  {number: '32',    name: 'Bette Churass'         },
  {number: '134',   name: 'B.J. HARMstrong'       },
  {number: '21',    name: 'B’kini Whacks'         },
  {number: '59',    name: 'Black Lizzard'         },
  {number: '97',    name: 'Brutali-Tease'         },
  {number: '90',    name: 'Busty Pipes'           },
  {number: '27',    name: 'Casual Sexist'         },
  {number: '64',    name: 'Celery Stalk-Her'      },
  {number: '1214',  name: 'Cha Cha Wheels'        },
  {number: '75',    name: 'Claire Violence'       },
  {number: '13',    name: 'C.N. Red'              },
  {number: '24',    name: 'Crazy Legs'            },
  {number: '38',    name: 'Crimes of Thrashin’'   },
  {number: '52',    name: 'CU~T'                  },
  {number: '00',    name: 'Dr. Dementer'          },
  {number: '87',    name: 'Evil-lyn Cognito'      },
  {number: '1125',  name: 'Fetishly Divine'       },
  {number: '68',    name: 'Her-Ass-Her'           },
  {number: '2008',  name: 'Hillary Collision'     },
  {number: '33',    name: 'Holly Lulu'            },
  {number: '667',   name: 'Hyper Bean'            },
  {number: '77',    name: 'Izzy Hung'             },
  {number: '47',    name: 'Jaded Sins-ability'    },
  {number: '37',    name: 'Juanita Hurtya'        },
  {number: '72',    name: 'KarnEvil'              },
  {number: '83',    name: 'Kelly Kapow-ski'       },
  {number: '911',   name: 'Kiki KonKussion'       },
  {number: '72',    name: 'Kiss This'             },
  {number: '57',    name: 'Knockin‘ Das Boots'    },
  {number: '31',    name: 'La Mala Rubia'         },
  {number: '71',    name: 'Lamb Chop'             },
  {number: '102',   name: 'Legs Luther'           },
  {number: '360',   name: 'Lipservice'            },
  {number: '15',    name: 'Liquid Courage'        },
  {number: '92',    name: 'Little Orphan Angry'   },
  {number: '30',    name: 'Lollypopz'             },
  {number: '93',    name: 'Mae Plower'            },
  {number: '140',   name: 'Maggie De Sade'        },
  {number: '91',    name: 'Merry Mayhem'          },
  {number: '420',   name: 'Mexicali Bruise'       },
  {number: '1985',  name: 'Neon Vamp'             },
  {number: '425',   name: 'NForceHer'             },
  {number: '70',    name: 'Notable Strumpet'      },
  {number: '79',    name: 'Notorious V.A.G.'      },
  {number: '35',    name: 'Peanut Bust-Her'       },
  {number: '60',    name: 'Pepper Stix'           },
  {number: '5',     name: 'Pissi Longstocking'    },
  {number: '65',    name: 'Poison Ivy League'     },
  {number: '25',    name: 'Pummelina'             },
  {number: '44',    name: 'R Rose Selavy'         },
  {number: '41',    name: 'Red Fox'               },
  {number: '51',    name: 'Roxanne Debris'        },
  {number: '10',    name: 'Ruby Revenge'          },
  {number: '80',    name: 'Sasa Skank'            },
  {number: '4',     name: 'Shake-Killa'           },
  {number: '138',   name: 'Sheer Tara'            },
  {number: '20/20', name: 'Sissy Fit'             },
  {number: '3',     name: 'Sissy Sparkles'        },
  {number: '916',   name: 'Sooky Smashhaus'       },
  {number: '23',    name: 'Sour Grapes'           },
  {number: '357',   name: 'Stormie Weather'       },
  {number: '007',   name: 'Supernova'             },
  {number: '82',    name: 'Tuesday Hula'          },
  {number: '36',    name: 'Unsung'                },
  {number: '56',    name: 'Vajenna Warrior'       },
  {number: '63',    name: 'Val du Morte'          },
  {                 name: 'Vanilla Creamz'        },
  {number: '18',    name: 'Violet Intentions'     },
  {number: '73',    name: 'Wrecks Kitten'         }
]);

public static function get app():QCRGScoreboard {
  return _app
}
protected static var _app:QCRGScoreboard

protected static function formatTime(time:int):String {
  return qcrg.formatTime(time, true)
}

[Bindable]
public function get bout():Bout {
  return _bout
}
public function set bout(value:Bout):void {
  if (bout) {
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
    bout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
        onBoutPropertyChange)
  }
}
protected var _bout:Bout

protected var commitField:Boolean

[Bindable]
public var displayGroup:DisplayGroup

protected var displays:ArrayCollection

protected var helper:WindowHelper

[Bindable]
public var preferences:Preferences

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

protected function onApplicationComplete(event:FlexEvent):void {
  var loader:Loader = new Loader()
  loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDisplayLoaderComplete)
  loader.load(new URLRequest('QueenCity3.swf'))
  stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true)
  // Linux glitch: doesn't adjust layout after adding menu bar.  On other
  // platforms, these should already be equal.
  height = stage.stageHeight
}

protected function onBoutPropertyChange(event:PropertyChangeEvent):void {
  var focused:IFocusManagerComponent = focusManager.getFocus()
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
    case 'timeoutClock':
      if (timeoutClockField != focused)
        timeoutClockField.text = formatTime(value)
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
  if (updates && 'update' in content) {
    content['update'](updates)
    updates = null
  }
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
  preferences = new Preferences()
  if (preferences.complete)
    onPreferencesComplete(null)
  preferences.addEventListener(Event.COMPLETE, onPreferencesComplete)
  helper = new WindowHelper('main', this, preferences)
  displayGroup = new DisplayGroup()
  displays = new ArrayCollection()
  updater = new GithubUpdater('zobar', 'qcrg-scoreboard', 'dist/update.xml')
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
    case Keyboard.B:
      bout.advance()
      break
    case Keyboard.G:
      if (bout.jamClock)
        bout.leadJammer = Team.HOME
      break
    case Keyboard.H:
      if (bout.jamClock)
        bout.leadJammer = Team.NONE
      break
    case Keyboard.J:
      if (bout.jamClock)
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

protected function onLineupClockFieldFocusOut(event:FocusEvent):void {
  fieldFocusOut(event, 'lineupClock', parseTime, formatTime)
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

protected function onPreferencesComplete(event:Event):void {
  bout = new Bout()
  updateScreens()
  BindingUtils.bindProperty(updater, 'branch', preferences, 'releaseTrack')
  if (preferences.autoUpdate)
    updater.check()
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

protected function updateDisplay(display:*):void {
  if (bout && display && 'update' in display) {
    display.update({
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

      visitorJamScore:   bout.visitorJamScore,
      visitorScore:      bout.visitorScore
    })
  }
}
