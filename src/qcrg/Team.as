package qcrg {
  import flash.display.BitmapData
  import mx.collections.ArrayCollection

  public class Team {
    public static const HOME:String = 'Home'
    public static const NONE:String = 'None'
    public static const VISITOR:String = 'Visitor'

    protected static var lastUntitledNumber:int

    [Bindable] public var image:BitmapData

    [Bindable]
    public function get name():String {
      if (_name == null)
        _name = 'Untitled Team ' + (++lastUntitledNumber)
      return _name
    }
    public function set name(value:String):void {
      _name = value
    }
    protected var _name:String

    [Bindable]
    public var people:ArrayCollection = new ArrayCollection([
      {enabled: true, number: '16',    name: 'Ace Bandage'           },
      {enabled: true, number: '525',   name: 'Addy Rawl'             },
      {enabled: true, number: '216',   name: 'Alablaster'            },
      {enabled: true, number: '42',    name: 'Alley Oops'            },
      {enabled: true, number: '19',    name: 'Argo'                  },
      {enabled: true, number: '17',    name: 'B-17'                  },
      {enabled: true, number: '40',    name: 'Babe Lincoln'          },
      {enabled: true, number: '613',   name: 'Bash-Full'             },
      {enabled: true, number: '6',     name: 'Bea Aggressive'        },
      {enabled: true, number: '55',    name: 'Beauty School Knockout'},
      {enabled: true, number: '32',    name: 'Bette Churass'         },
      {enabled: true, number: '134',   name: 'B.J. HARMstrong'       },
      {enabled: true, number: '21',    name: 'B’kini Whacks'         },
      {enabled: true, number: '59',    name: 'Black Lizzard'         },
      {enabled: true, number: '97',    name: 'Brutali-Tease'         },
      {enabled: true, number: '90',    name: 'Busty Pipes'           },
      {enabled: true, number: '27',    name: 'Casual Sexist'         },
      {enabled: true, number: '64',    name: 'Celery Stalk-Her'      },
      {enabled: true, number: '1214',  name: 'Cha Cha Wheels'        },
      {enabled: true, number: '75',    name: 'Claire Violence'       },
      {enabled: true, number: '13',    name: 'C.N. Red'              },
      {enabled: true, number: '24',    name: 'Crazy Legs'            },
      {enabled: true, number: '38',    name: 'Crimes of Thrashin’'   },
      {enabled: true, number: '52',    name: 'CU~T'                  },
      {enabled: true, number: '00',    name: 'Dr. Dementer'          },
      {enabled: true, number: '87',    name: 'Evil-lyn Cognito'      },
      {enabled: true, number: '1125',  name: 'Fetishly Divine'       },
      {enabled: true, number: '68',    name: 'Her-Ass-Her'           },
      {enabled: true, number: '2008',  name: 'Hillary Collision'     },
      {enabled: true, number: '33',    name: 'Holly Lulu'            },
      {enabled: true, number: '667',   name: 'Hyper Bean'            },
      {enabled: true, number: '77',    name: 'Izzy Hung'             },
      {enabled: true, number: '47',    name: 'Jaded Sins-ability'    },
      {enabled: true, number: '37',    name: 'Juanita Hurtya'        },
      {enabled: true, number: '72',    name: 'KarnEvil'              },
      {enabled: true, number: '83',    name: 'Kelly Kapow-ski'       },
      {enabled: true, number: '911',   name: 'Kiki KonKussion'       },
      {enabled: true, number: '72',    name: 'Kiss This'             },
      {enabled: true, number: '57',    name: 'Knockin‘ Das Boots'    },
      {enabled: true, number: '31',    name: 'La Mala Rubia'         },
      {enabled: true, number: '71',    name: 'Lamb Chop'             },
      {enabled: true, number: '102',   name: 'Legs Luther'           },
      {enabled: true, number: '360',   name: 'Lipservice'            },
      {enabled: true, number: '15',    name: 'Liquid Courage'        },
      {enabled: true, number: '92',    name: 'Little Orphan Angry'   },
      {enabled: true, number: '30',    name: 'Lollypopz'             },
      {enabled: true, number: '93',    name: 'Mae Plower'            },
      {enabled: true, number: '140',   name: 'Maggie De Sade'        },
      {enabled: true, number: '91',    name: 'Merry Mayhem'          },
      {enabled: true, number: '420',   name: 'Mexicali Bruise'       },
      {enabled: true, number: '1985',  name: 'Neon Vamp'             },
      {enabled: true, number: '425',   name: 'NForceHer'             },
      {enabled: true, number: '70',    name: 'Notable Strumpet'      },
      {enabled: true, number: '79',    name: 'Notorious V.A.G.'      },
      {enabled: true, number: '35',    name: 'Peanut Bust-Her'       },
      {enabled: true, number: '60',    name: 'Pepper Stix'           },
      {enabled: true, number: '5',     name: 'Pissi Longstocking'    },
      {enabled: true, number: '65',    name: 'Poison Ivy League'     },
      {enabled: true, number: '25',    name: 'Pummelina'             },
      {enabled: true, number: '44',    name: 'R Rose Selavy'         },
      {enabled: true, number: '41',    name: 'Red Fox'               },
      {enabled: true, number: '51',    name: 'Roxanne Debris'        },
      {enabled: true, number: '10',    name: 'Ruby Revenge'          },
      {enabled: true, number: '80',    name: 'Sasa Skank'            },
      {enabled: true, number: '4',     name: 'Shake-Killa'           },
      {enabled: true, number: '138',   name: 'Sheer Tara'            },
      {enabled: true, number: '20/20', name: 'Sissy Fit'             },
      {enabled: true, number: '3',     name: 'Sissy Sparkles'        },
      {enabled: true, number: '916',   name: 'Sooky Smashhaus'       },
      {enabled: true, number: '23',    name: 'Sour Grapes'           },
      {enabled: true, number: '357',   name: 'Stormie Weather'       },
      {enabled: true, number: '007',   name: 'Supernova'             },
      {enabled: true, number: '82',    name: 'Tuesday Hula'          },
      {enabled: true, number: '36',    name: 'Unsung'                },
      {enabled: true, number: '56',    name: 'Vajenna Warrior'       },
      {enabled: true, number: '63',    name: 'Val du Morte'          },
      {                 name: 'Vanilla Creamz'        },
      {enabled: true, number: '18',    name: 'Violet Intentions'     },
      {enabled: true, number: '73',    name: 'Wrecks Kitten'         }
    ])
  }
}
