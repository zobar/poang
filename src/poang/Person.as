package poang {
  import flash.display.BitmapData
  import flash.utils.ByteArray
  import mx.collections.ArrayCollection

  public class Person extends LibraryItem {
    [Bindable]
    public function get image():BitmapData {
      return getBitmap('image')
    }
    public function set image(value:BitmapData):void {
      setBitmap('image', value)
    }

    [Bindable] public var isJammer:Boolean

    override internal function set library(value:Library):void {
      super.library = value
      library.addPerson(this)
    }

    [Bindable]
    public function get name():String {
      return getString('name', '')
    }
    public function set name(value:String):void {
      setString('name', value, '')
    }

    [Bindable]
    public function get number():String {
      return getString('number', '')
    }
    public function set number(value:String):void {
      setString('number', value, '')
    }

    public function setImage(bitmap:BitmapData, data:ByteArray):void {
      setBitmap('image', bitmap, data)
    }
  }
}
