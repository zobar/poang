package qcrg {
  import flash.events.EventDispatcher

  public class AbstractRuleset extends EventDispatcher implements IRuleset {
    [Bindable] public var intermissionLength:int
    [Bindable] public var jamLength:int
    [Bindable] public var lineupLength:int
    [Bindable] public var overtimeLineupLength:int
    [Bindable] public var periodLength:int
    [Bindable] public var periods:int
    [Bindable] public var timeoutLength:int
    [Bindable] public var timeouts:int
    [Bindable] public var timeoutsPer:String
  }
}
