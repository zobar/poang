package dpk.skins {
  import flash.events.Event
  import spark.skins.SparkSkin

  public class Skin extends SparkSkin {
    [Bindable(event='backgroundImageChanged')]
    public function get backgroundImage():Object {
      return getStyle('backgroundImage')
    }

    public function set backgroundImage(value:Object):void {
      setStyle('backgroundImage', value)
    }

    [Bindable(event='backgroundImageFillModeChanged')]
    public function get backgroundImageFillMode():String {
      return getStyle('backgroundImageFillMode')
    }

    public function set backgroundImageFillMode(value:String):void {
      setStyle('backgroundImageFillMode', value)
    }

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
      return Math.max(getStyle('cornerRadius') - 1, 0)
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

    [Bindable(event='paddingBottomChanged')]
    public function get paddingBottom():Number {
      return getStyle('paddingBottom')
    }

    public function set paddingBottom(value:Number):void {
      setStyle('paddingBottom', value)
    }

    [Bindable(event='paddingLeftChanged')]
    public function get paddingLeft():Number {
      return getStyle('paddingLeft')
    }

    public function set paddingLeft(value:Number):void {
      setStyle('paddingLeft', value)
    }

    [Bindable(event='paddingRightChanged')]
    public function get paddingRight():Number {
      return getStyle('paddingRight')
    }

    public function set paddingRight(value:Number):void {
      setStyle('paddingRight', value)
    }

    [Bindable(event='paddingTopChanged')]
    public function get paddingTop():Number {
      return getStyle('paddingTop')
    }

    public function set paddingTop(value:Number):void {
      setStyle('paddingTop', value)
    }

    override public function styleChanged(styleProp:String):void {
      var all:Boolean = !styleProp || styleProp == 'styleName'
      super.styleChanged(styleProp)
      if (all || styleProp == 'backgroundImage')
        dispatchEvent(new Event('backgroundImageChanged'))
      if (all || styleProp == 'backgroundImageFillMode')
        dispatchEvent(new Event('backgroundImageFillModeChanged'))
      if (all || styleProp == 'borderColor')
        dispatchEvent(new Event('borderColorChanged'))
      if (all || styleProp == 'chromeColor')
        dispatchEvent(new Event('chromeColorChanged'))
      if (all || styleProp == 'contentBackgroundColor')
        dispatchEvent(new Event('contentBackgroundColorChanged'))
      if (all || styleProp == 'cornerRadius')
        dispatchEvent(new Event('cornerRadiusChanged'))
      if (all || styleProp == 'paddingBottom')
        dispatchEvent(new Event('paddingBottomChanged'))
      if (all || styleProp == 'paddingLeft')
        dispatchEvent(new Event('paddingLeftChanged'))
      if (all || styleProp == 'paddingRight')
        dispatchEvent(new Event('paddingRightChanged'))
      if (all || styleProp == 'paddingTop')
        dispatchEvent(new Event('paddingTopChanged'))
    }
  }
}
