import mx.events.StateChangeEvent

protected var cornerRadiusChanged:Boolean

override public function set owner(value:DisplayObjectContainer):void {
  if (value != owner) {
    if (owner) {
      owner.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,
          onOwnerCurrentStateChange)
    }
    super.owner = value
    if (owner) {
      owner.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,
          onOwnerCurrentStateChange)
    }
    styleChanged(null)
  }
}

override public function getStyle(styleName:String):* {
  if (owner && owner is IStyleClient)
    return IStyleClient(owner).getStyle(styleName)
  else
    return super.getStyle(styleName)
}

override public function styleChanged(styleProp:String):void {
  var allStyles:Boolean = !styleProp || styleProp == 'styleName'

  super.styleChanged(styleProp)
  if (allStyles || styleProp == 'cornerRadius') {
    cornerRadiusChanged = true
    invalidateDisplayList()
  }
}

protected function onOwnerCurrentStateChange(event:StateChangeEvent):void {
  currentState = event.currentTarget.currentState
}

override protected function updateDisplayList(unscaledWidth:Number,
    unscaledHeight:Number):void {
  var chromeColor:uint = getStyle('chromeColor')
  borderStroke.color = getStyle('borderColor')
  if (borderSelected)
    borderSelectedStroke.color = chromeColor
  if (highlightFill)
    highlightFill.color = chromeColor
  if (cornerRadiusChanged) {
    var cornerRadius:Number = getStyle('cornerRadius')
    var innerCornerRadius:Number = cornerRadius - 1
    border.radiusX = border.radiusY = cornerRadius
    if (borderSelected)
      borderSelected.radiusX = borderSelected.radiusY = cornerRadius
    dropShadow.radiusX = dropShadow.radiusY = cornerRadius + 1
    highlightFillRect.radiusX = highlightFillRect.radiusY = cornerRadius - 1.5
    for each (var rect:Rect in [background, downHighlight, highlightStrokeRect,
        overHighlight, selectedBackground]) {
      if (rect)
        rect.radiusX = rect.radiusY = innerCornerRadius
    }
    cornerRadiusChanged = false
  }
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}
