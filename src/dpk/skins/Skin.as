package dpk.skins {
  import flash.events.Event
  import spark.skins.SparkSkin

  public class Skin extends SparkSkin {
    [Bindable(event='borderColorChanged')]
    public function get borderColor():uint {
      return getStyle('borderColor')
    }

    public function set borderColor(value:uint):void {
      setStyle('borderColor', value)
    }

    [Bindable(event='chromeColorChanged')]
    public function get chromeColor():uint {
      return getStyle('chromeColor')
    }

    public function set chromeColor(value:uint):void {
      setStyle('chromeColor', value)
    }

    [Bindable(event='contentBackgroundColorChanged')]
    public function get contentBackgroundColor():uint {
      return getStyle('contentBackgroundColor')
    }

    public function set contentBackgroundColor(value:uint):void {
      setStyle('contentBackgroundColor', value)
    }

    [Bindable(event='cornerRadiusChanged')]
    public function get cornerRadius():Number {
      return getStyle('cornerRadius')
    }

    public function set cornerRadius(value:Number):void {
      setStyle('cornerRadius', value)
    }

    [Bindable(event='cornerRadiusChanged')]
    public function get innerCornerRadius():Number {
      return getStyle('cornerRadius') - 1
    }

    public function set innerCornerRadius(value:Number):void {
      setStyle('cornerRadius', value + 1)
    }

    [Bindable(event='cornerRadiusChanged')]
    public function get outerCornerRadius():Number {
      return getStyle('cornerRadius') + 1
    }

    public function set outerCornerRadius(value:Number):void {
      setStyle('cornerRadius', value - 1)
    }

    override public function styleChanged(styleProp:String):void {
      var all:Boolean = !styleProp || styleProp == 'styleName'
      super.styleChanged(styleProp)
      if (all || styleProp == 'borderColor')
        dispatchEvent(new Event('borderColorChanged'))
      if (all || styleProp == 'chromeColor')
        dispatchEvent(new Event('chromeColorChanged'))
      if (all || styleProp == 'contentBackgroundColor')
        dispatchEvent(new Event('contentBackgroundColorChanged'))
      if (all || styleProp == 'cornerRadius')
        dispatchEvent(new Event('cornerRadiusChanged'))
    }
  }
}
