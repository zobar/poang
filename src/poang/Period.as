package poang {
  public class Period {
    public static const FINAL:int = -3
    public static const INTERMISSION:int = -1
    public static const NONE:int = 0
    public static const OVERTIME:int = -2

    public static function toString(period:int):String {
      if (period > 0)
        return 'Period ' + period
      else {
        switch (period) {
          case FINAL:
            return 'Final'
          case INTERMISSION:
            return 'Intermission'
          case OVERTIME:
            return 'Overtime'
        }
      }
      return ''
    }
  }
}
