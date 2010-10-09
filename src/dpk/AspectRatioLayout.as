package dpk {
  import mx.core.UIComponent
  import spark.layouts.supportClasses.LayoutBase

  public class AspectRatioLayout extends LayoutBase {
    [Bindable]
    public function get adjustHeight():Number {
      return _adjustHeight
    }
    public function set adjustHeight(value:Number):void {
      if (adjustHeight != value) {
        _adjustHeight = value
        if (target)
          target.invalidateDisplayList()
      }
    }
    protected var _adjustHeight:Number

    [Bindable]
    public function get adjustWidth():Number {
      return _adjustWidth
    }
    public function set adjustWidth(value:Number):void {
      if (adjustWidth != value) {
        _adjustWidth = value
        if (target)
          target.invalidateDisplayList()
      }
    }
    protected var _adjustWidth:Number

    [Bindable]
    public function get aspectRatio():Number {
      return _aspectRatio
    }
    public function set aspectRatio(value:Number):void {
      if (aspectRatio != value) {
        _aspectRatio = value
        if (target)
          target.invalidateDisplayList()
      }
    }
    protected var _aspectRatio:Number

    public function AspectRatioLayout() {
      adjustHeight = 0
      adjustWidth = 0
      aspectRatio = 4/3
    }

    override public function measure():void {
      var measuredHeight:Number = 0
      var measuredMinHeight:Number = 0
      var measuredMinWidth:Number = 0
      var measuredWidth:Number = 0
      for (var i:int = 0; i < target.numChildren; ++i) {
        var child:UIComponent = UIComponent(target.getChildAt(i))
        measuredHeight = Math.max(measuredHeight,
            child.getExplicitOrMeasuredHeight())
        measuredMinHeight = Math.max(measuredMinHeight, child.measuredMinHeight)
        measuredMinWidth = Math.max(measuredMinWidth, child.measuredMinWidth)
        measuredWidth = Math.max(measuredWidth,
            child.getExplicitOrMeasuredWidth())
      }
      target.measuredHeight = measuredHeight
      target.measuredMinHeight = measuredMinHeight
      target.measuredMinWidth = measuredMinWidth
      target.measuredWidth = measuredWidth
    }

    override public function updateDisplayList(width:Number, height:Number):void {
      var childHeight:Number = (height - adjustHeight)
      var childWidth:Number = (width - adjustWidth)
      var allottedAspectRatio:Number = childWidth / childHeight
      var x:Number = 0
      var y:Number = 0
      if (allottedAspectRatio >= aspectRatio) {
        childWidth = childHeight * aspectRatio
        x = (width - childWidth) / 2
        y = adjustHeight / 2
      }
      else {
        childHeight = childWidth / aspectRatio
        x = adjustWidth / 2
        y = (height - childHeight) / 2
      }
      for (var i:int = 0; i < target.numChildren; ++i) {
        var child:UIComponent = UIComponent(target.getChildAt(i))
        child.move(Math.round(x - (adjustWidth / 2)),
            Math.round(y - (adjustHeight / 2)))
        child.setActualSize(Math.round(childWidth + adjustWidth),
            Math.round(childHeight + adjustHeight))
      }
    }
  }
}
