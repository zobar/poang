package qcrg {
  public class Period {
    public static const FINAL:int = -2
    public static const INTERMISSION:int = -1
    public static const NONE:int = 0
    public static const OVERTIME:int = 3

    public static function toString(period:int):String {
      if (period > 2)
        return 'Overtime'
      else if (period > 0)
        return 'Period ' + period
      else {
        switch (period) {
          case FINAL:
            return 'Final'
          case INTERMISSION:
            return 'Intermission'
        }
      }
      return ''
    }
  }
}
