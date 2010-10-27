import mx.collections.ArrayCollection
import mx.events.FlexEvent
import mx.events.FlexNativeWindowBoundsEvent
import mx.events.ResizeEvent
import mx.managers.ISystemManager
import qcrg.PreferencesWindow

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

protected function onCloseSelect(event:Event):void {
  var activeNativeWindow:NativeWindow =
      NativeApplication.nativeApplication.activeWindow
  if (activeNativeWindow)
    ISystemManager(activeNativeWindow.stage.getChildAt(0)).document.close()
}

protected function onApplicationComplete(event:FlexEvent):void {
  // Linux glitch: doesn't adjust layout after adding menu bar.  On other
  // platforms, these should already be equal.
  height = stage.stageHeight
}

protected function onPreferencesSelect(event:Event):void {
  if (preferencesWindow)
    preferencesWindow.activate()
  else {
    preferencesWindow = new PreferencesWindow()
    preferencesWindow.open()
  }
}

protected function onPreferencesWindowClose(event:Event):void {
  preferencesWindow = null
}

protected function onPreviewResize(event:Event):void {
  trace('Resize preview ' + (event.currentTarget.width - 2) + 'x' +
      (event.currentTarget.height - 2))
}

protected function onResize(event:ResizeEvent):void {
  trace('Resize application ' + width + 'x' + height)
}

protected function onQuitSelect(event:Event):void {
  exit()
}

protected function onWindowResize(event:FlexNativeWindowBoundsEvent):void {
  trace('Resize window ' + event.afterBounds)
}
