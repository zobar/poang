override protected function updateDisplayList(unscaledWidth:Number,
    unscaledHeight:Number):void {
  if (borderStroke)
    borderStroke.color = getStyle('borderColor')
  super.updateDisplayList(unscaledWidth, unscaledHeight)
}
