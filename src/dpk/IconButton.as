package dpk {
  import spark.components.supportClasses.ButtonBase

  public class IconButton extends ButtonBase {
    [Bindable]
    public function get icon():* {
      return _icon
    }
    public function set icon(value:*):void {
      _icon = value
      invalidateProperties()
    }
    protected var _icon:*

    override public function validateProperties():void {
      super.validateProperties()
      skin['iconDisplay'].source = icon
    }
  }
}
