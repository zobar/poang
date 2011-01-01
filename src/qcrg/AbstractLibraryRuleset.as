package qcrg {
  public class AbstractLibraryRuleset extends LibraryItem implements IRuleset {
    [Bindable]
    public function get intermissionLength():int {
      return getInt('intermissionLength', ruleset.intermissionLength)
    }
    public function set intermissionLength(value:int):void {
      setInt('intermissionLength', value, ruleset.intermissionLength)
    }

    [Bindable]
    public function get jamLength():int {
      return getInt('jamLength', ruleset.jamLength)
    }
    public function set jamLength(value:int):void {
      setInt('jamLength', value, ruleset.jamLength)
    }

    [Bindable]
    public function get lineupLength():int {
      return getInt('lineupLength', ruleset.lineupLength)
    }
    public function set lineupLength(value:int):void {
      setInt('lineupLength', value, ruleset.lineupLength)
    }

    [Bindable]
    public function get overtimeLineupLength():int {
      return getInt('overtimeLineupLength', ruleset.overtimeLineupLength)
    }
    public function set overtimeLineupLength(value:int):void {
      setInt('overtimeLineupLength', value, ruleset.overtimeLineupLength)
    }

    [Bindable]
    public function get periodLength():int {
      return getInt('periodLength', ruleset.periodLength)
    }
    public function set periodLength(value:int):void {
      setInt('periodLength', value, ruleset.periodLength)
    }

    [Bindable]
    public function get periods():int {
      return getInt('periods', ruleset.periods)
    }
    public function set periods(value:int):void {
      setInt('periods', value, ruleset.periods)
    }

    [Bindable]
    public function get ruleset():IRuleset {
      return _ruleset
    }
    public function set ruleset(value:IRuleset):void {
      _ruleset = value
    }
    protected var _ruleset:IRuleset

    [Bindable]
    public function get timeoutLength():int {
      return getInt('timeoutLength', ruleset.timeoutLength)
    }
    public function set timeoutLength(value:int):void {
      setInt('timeoutLength', value, ruleset.timeoutLength)
    }

    [Bindable]
    public function get timeouts():int {
      return getInt('timeouts', ruleset.timeouts)
    }
    public function set timeouts(value:int):void {
      setInt('timeouts', value, ruleset.timeouts)
    }

    [Bindable]
    public function get timeoutsPer():String {
      return getString('timeoutsPer', ruleset.timeoutsPer)
    }
    public function set timeoutsPer(value:String):void {
      setString('timeoutsPer', value, ruleset.timeoutsPer)
    }
  }
}
