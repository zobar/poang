override protected function commitProperties():void {
  super.commitProperties()
  textDisplay.setStyle('paddingBottom', getStyle('paddingBottom'))
  textDisplay.setStyle('paddingLeft', getStyle('paddingLeft'))
  textDisplay.setStyle('paddingRight', getStyle('paddingRight'))
  textDisplay.setStyle('paddingTop', getStyle('paddingTop'))
}
