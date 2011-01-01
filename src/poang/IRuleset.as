package poang {
  public interface IRuleset {
    function get intermissionLength():int
    function set intermissionLength(value:int):void

    function get jamLength():int
    function set jamLength(value:int):void

    function get lineupLength():int
    function set lineupLength(value:int):void

    function get overtimeLineupLength():int
    function set overtimeLineupLength(value:int):void

    function get periodLength():int
    function set periodLength(value:int):void

    function get periods():int
    function set periods(value:int):void

    function get timeoutLength():int
    function set timeoutLength(value:int):void

    function get timeouts():int
    function set timeouts(value:int):void

    function get timeoutsPer():String
    function set timeoutsPer(value:String):void
  }
}
