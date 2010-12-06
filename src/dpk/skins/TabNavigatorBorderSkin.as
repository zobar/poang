package dpk.skins {
  public class TabNavigatorBorderSkin extends BorderSkin {
    override protected function updateDisplayList(unscaledWidth:Number,
        unscaledHeight:Number):void {
      var cornerRadius:Number = getStyle('cornerRadius')
      border.topLeftRadiusX = border.topLeftRadiusY = 0
      dropShadow.topLeftRadiusX = dropShadow.topLeftRadiusY = 0
      super.updateDisplayList(unscaledWidth, unscaledHeight)
    }
  }
}
