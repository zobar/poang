package qcrg {
  public class Team {
    public static const HOME:String = 'Home'
    public static const NONE:String = 'None'
    public static const VISITOR:String = 'Visitor'

    protected static var lastUntitledNumber:int

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
  }
}
