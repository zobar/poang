package framsta {
  import flash.display.MovieClip
  import flash.text.TextField

  public class Intro extends MovieClip {
    protected var bout:Object

    public function get imagePlaceholder():Placeholder {
      return _imagePlaceholder
    }
    public function set imagePlaceholder(value:Placeholder):void {
      _imagePlaceholder = value
      updateImage()
    }
    protected var _imagePlaceholder:Placeholder

    public function get nameField():TextField {
      return _nameField
    }
    public function set nameField(value:TextField):void {
      _nameField = value
      updateName()
    }
    protected var _nameField:TextField

    public function get personImagePlaceholder():Placeholder {
      return _personImagePlaceholder
    }
    public function set personImagePlaceholder(value:Placeholder):void {
      _personImagePlaceholder = value
      updatePersonImage()
    }
    protected var _personImagePlaceholder:Placeholder

    public function get personNameField():TextField {
      return _personNameField
    }
    public function set personNameField(value:TextField):void {
      _personNameField = value
      updatePersonName()
    }
    protected var _personNameField:TextField

    public function get personNumberField():TextField {
      return _personNumberField
    }
    public function set personNumberField(value:TextField):void {
      _personNumberField = value
      updatePersonNumber()
    }
    protected var _personNumberField:TextField

    protected var which:String

    public function Intro() {
      which = 'home'
    }

    public function update(values:Object):void {
      var firstUpdate:Boolean = (bout == null)
      var oldJammerName:String = firstUpdate ? null : bout[which + 'JammerName']
      if (firstUpdate)
        bout = values
      else {
        for (var property:String in values)
          bout[property] = values[property]
      }
      if ('mediaName' in values)
        updateWhich()
      if (which + 'Image' in values)
        updateImage()
      if (firstUpdate)
        gotoAndPlay(1)
      else if (bout[which + 'JammerName'] != oldJammerName)
        play()
      if (which + 'Name' in values)
        updateName()
    }

    protected function updateImage():void {
      var image:String = which + 'Image'
      if (bout && imagePlaceholder && image in bout)
        imagePlaceholder.bitmapData = bout[image]
    }

    protected function updateName():void {
      var name:String = which + 'Name'
      if (bout && nameField && name in bout)
        nameField.text = bout[name] ? bout[name] : ''
    }

    protected function updatePersonImage():void {
      var personImage:String = which + 'JammerImage'
      if (bout && personImagePlaceholder && personImage in bout)
        personImagePlaceholder.bitmapData = bout[personImage]
    }

    protected function updatePersonName():void {
      var personName:String = which + 'JammerName'
      if (bout && personNameField && personName in bout)
        personNameField.text = bout[personName] ? bout[personName] : ''
    }

    protected function updatePersonNumber():void {
      var personNumber:String = which + 'JammerNumber'
      if (bout && personNumberField && personNumber in bout)
        personNumberField.text = bout[personNumber] ? bout[personNumber] : ''
    }

    protected function updateWhich():void {
      var mediaName:String = bout.mediaName
      if (/visitor/i.test(mediaName))
        which = 'visitor'
      else
        which = 'home'
    }
  }
}
