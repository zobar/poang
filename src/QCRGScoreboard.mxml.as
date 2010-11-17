import dpk.GithubUpdater
import dpk.minutes
import dpk.seconds
import dpk.UpdateEvent
import dpk.WindowHelper
import flash.events.FocusEvent
import mx.binding.utils.BindingUtils
import mx.collections.ArrayCollection
import mx.events.FlexEvent
import mx.events.PropertyChangeEvent
import mx.managers.IFocusManagerComponent
import mx.managers.ISystemManager
import qcrg.Bout
import qcrg.Period
import qcrg.Preferences
import qcrg.PreferencesWindow
import qcrg.UpdateCompleteWindow
import qcrg.UpdateNotificationWindow
import spark.events.IndexChangeEvent
import spark.events.TextOperationEvent

[Bindable]
public var periods:ArrayCollection = new ArrayCollection([0, 1, -1, 2, -2, 3]);

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

// This is a restricted variation of dpk.formatTime() which is always compatible
// with QCRGScoreboard.parseTime().
protected static function formatTime(value:int):String {
  return int(value / 60000) + ':' + int((value / 10000) % 6) +
      int((value / 1000) % 10)
}


protected static function parseTime(time:String):Number {
  var parts:Object = /(.*?)(.{1,2})$/.exec(time.replace(/[^0-9]+/g, ''))
  if (parts) {
    return minutes(parts[1] ? parseInt(parts[1]) : 0) +
        seconds(parseInt(parts[2]))
  }
  else
    return NaN
}

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
    bout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
        onBoutPropertyChange)
  }
}
protected var _bout:Bout

protected var commitField:Boolean
protected var helper:WindowHelper

public function get preferences():Preferences {
  return _preferences
}
public function set preferences(value:Preferences):void {
  if (value != preferences) {
    _preferences = value
  }
}
protected var _preferences:Preferences

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

protected var windowHelper:WindowHelper

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
  stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true)
  // Linux glitch: doesn't adjust layout after adding menu bar.  On other
  // platforms, these should already be equal.
  height = stage.stageHeight
}

protected function onBoutPropertyChange(event:PropertyChangeEvent):void {
  var focused:IFocusManagerComponent = focusManager.getFocus()
  var value:* = event.newValue
  switch (event.property) {
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
}

protected function onClose(event:Event):void {
  exit()
}

protected function onCloseSelect(event:Event):void {
  var activeNativeWindow:NativeWindow =
      NativeApplication.nativeApplication.activeWindow
  if (activeNativeWindow)
    ISystemManager(activeNativeWindow.stage.getChildAt(0)).document.close()
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
  helper = new WindowHelper('main', this, preferences)
  updater = new GithubUpdater('zobar', 'qcrg-scoreboard', 'dist/update.xml')
  if (preferences.complete)
    onPreferencesComplete(null)
  preferences.addEventListener(Event.COMPLETE, onPreferencesComplete)
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
    case Keyboard.N:
      bout.officialTimeout = !bout.officialTimeout
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
  trace('choose, focused = ' + focusManager.getFocus())
  if (periodList == focusManager.getFocus())
    commitField = true
  else
    bout.period = periodList.selectedItem
}

protected function onPeriodListFocusIn(event:FocusEvent):void {
  trace('focus in')
  commitField = false
}

protected function onPeriodListFocusOut(event:FocusEvent):void {
  trace('focus out')
  if (commitField)
    bout.period = periodList.selectedItem
  else
    periodList.selectedItem = bout.period
}

protected function onPreferencesComplete(event:Event):void {
  bout = new Bout()
  BindingUtils.bindProperty(updater, 'branch', preferences, 'releaseTrack')
  if (preferences.autoUpdate)
    updater.check()
}

protected function onPreferencesSelect(event:Event):void {
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

protected function onQuitSelect(event:Event):void {
  exit()
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

protected function periodListLabelFunction(value:int):String {
  return Period.toString(value)
}
