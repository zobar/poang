package qcrg {
  import flash.display.BitmapData
  import flash.utils.ByteArray
  import mx.collections.ArrayCollection

  public class Team extends LibraryItem {
    public static const HOME:String = 'Home'
    public static const NONE:String = 'None'
    public static const VISITOR:String = 'Visitor';

    [Bindable]
    public function get image():BitmapData {
      return getBitmap('image')
    }
    public function set image(value:BitmapData):void {
      setBitmap('image', value)
    }

    [Bindable]
    public function get name():String {
      return getString('name')
    }
    public function set name(value:String):void {
      setString('name', value)
    }

    [Bindable]
    public function get people():ArrayCollection {
      return getObjectList(Person, 'person')
    }
    public function set people(value:ArrayCollection):void {
      setObjectList('person', value)
    }

    override internal function set library(value:Library):void {
      super.library = value
      library.addTeam(this)
    }

    public function Team() {
    }

    public function setImage(bitmap:BitmapData, data:ByteArray):void {
      setBitmap('image', bitmap, data)
    }
  }
}
