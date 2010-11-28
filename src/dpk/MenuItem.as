package dpk {
  import flash.display.NativeMenuItem
  import flash.ui.Keyboard

  [DefaultProperty('children')]
  public class MenuItem extends MenuItemBase {
    public function get altKey():Boolean {
      return _altKey
    }
    public function set altKey(value:Boolean):void {
      if (altKey != value) {
        _altKey = value
        if (nativeMenuItem)
          updateAltKey()
      }
    }
    protected var _altKey:Boolean

    public function get checked():Boolean {
      return _checked
    }
    public function set checked(value:Boolean):void {
      if (checked != value) {
        _checked = value
        if (nativeMenuItem)
          nativeMenuItem.checked = checked
      }
    }
    protected var _checked:Boolean

    public function get keyEquivalent():String {
      return _keyEquivalent
    }
    public function set keyEquivalent(value:String):void {
      if (keyEquivalent != value) {
        _keyEquivalent = value
        if (nativeMenuItem)
          nativeMenuItem.keyEquivalent = keyEquivalent
      }
    }
    protected var _keyEquivalent:String

    override public function set nativeMenuItem(value:NativeMenuItem):void {
      if (nativeMenuItem != value) {
        super.nativeMenuItem = value
        if (nativeMenuItem) {
          if (label) {
            nativeMenuItem.checked = checked
            nativeMenuItem.keyEquivalent = keyEquivalent
            updateAltKey()
          }
          else {
            altKey =
                nativeMenuItem.keyEquivalentModifiers.indexOf(
                Keyboard.ALTERNATE) != -1
            checked = nativeMenuItem.checked
            keyEquivalent = nativeMenuItem.keyEquivalent
          }
        }
      }
    }

    protected function updateAltKey():void {
      var modifiers:Array = []
      if (altKey)
        modifiers.push(Keyboard.ALTERNATE)
      for each (var modifier:uint in
          nativeMenuItem.keyEquivalentModifiers) {
        if (modifier != Keyboard.ALTERNATE)
          modifiers.push(modifier)
      }
      nativeMenuItem.keyEquivalentModifiers = modifiers
    }
  }
}
