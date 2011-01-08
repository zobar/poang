package poang {
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.DisplayObject
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.geom.Matrix
  import flash.geom.Matrix3D
  import flash.geom.PerspectiveProjection
  import flash.geom.Rectangle
  import mx.collections.ArrayCollection
  import mx.events.CollectionEvent
  import mx.events.CollectionEventKind
  import mx.events.ResizeEvent

  public class DisplayGroup extends EventDispatcher {
    [Bindable]
    public var bitmapData:BitmapData

    [Bindable]
    public function get content():DisplayObject {
      return _content
    }
    public function set content(value:DisplayObject):void {
      setContent(value)
    }
    protected var _content:DisplayObject

    public function get contentBounds():Rectangle {
      return _contentBounds
    }
    public function set contentBounds(value:Rectangle):void {
      _contentBounds = value
      contentBoundsChanged = true
      invalidate()
    }
    protected var _contentBounds:Rectangle

    protected var contentBoundsChanged:Boolean
    protected var contentTransform:Matrix
    protected var drawn:BitmapData
    protected var maxSize:Rectangle

    public function get displays():ArrayCollection {
      return _displays
    }
    public function set displays(value:ArrayCollection):void {
      if (displays) {
        displays.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
            onDisplaysCollectionChange)
      }
      _displays = value
      if (displays) {
        displays.addEventListener(CollectionEvent.COLLECTION_CHANGE,
            onDisplaysCollectionChange)
      }
    }
    protected var _displays:ArrayCollection

    public function DisplayGroup() {
      displays = new ArrayCollection()
    }

    public function setContent(value:DisplayObject,
        bounds:Rectangle=null):void {
      if (content)
        content.removeEventListener(Event.ENTER_FRAME, onContentEnterFrame)
      _content = value
      if (content) {
        contentBounds = bounds ? bounds : content.getBounds(content)
        if (!(content is Bitmap))
          content.addEventListener(Event.ENTER_FRAME, onContentEnterFrame)
      }
      invalidate()
    }

    protected function drawBitmap():void {
      if (bitmapData != drawn) {
        bitmapData.lock()
        bitmapData.fillRect(new Rectangle(0, 0, bitmapData.width,
            bitmapData.height), 0x000000)
        bitmapData.draw(content, contentTransform)
        bitmapData.unlock()
      }
      drawn = bitmapData
    }

    protected function onContentEnterFrame(event:Event):void {
      drawBitmap()
      drawn = null
    }

    protected function onDisplayResize(event:ResizeEvent):void {
      var display:Display = Display(event.currentTarget)
      var h:Number = display.height
      var w:Number = display.width
      if (!maxSize)
        maxSize = new Rectangle()
      if (h > maxSize.height)
        maxSize.height = h
      else if (event.oldHeight >= maxSize.height) {
        maxSize.height = 0
        for each (display in displays)
          maxSize.height = Math.max(maxSize.height, display.height)
      }
      if (w > maxSize.width)
        maxSize.width = w
      else if (event.oldWidth >= maxSize.width) {
        maxSize.width = 0
        for each (display in displays)
          maxSize.width = Math.max(maxSize.width, display.width)
      }
      invalidate()
    }

    protected function
        onDisplaysCollectionChange(event:CollectionEvent):void {
      var h:Number
      var display:Display
      var w:Number
      switch (event.kind) {
        case CollectionEventKind.ADD:
          for each (display in event.items) {
            h = display.height
            w = display.width
            display.addEventListener(ResizeEvent.RESIZE, onDisplayResize)
            if (!maxSize)
              maxSize = new Rectangle()
            if (h > maxSize.height)
              maxSize.height = h
            if (w > maxSize.width)
              maxSize.width = w
          }
          invalidate()
          break
        case CollectionEventKind.REMOVE:
          maxSize.height = 0
          maxSize.width = 0
          for (var i:int = 0; i < displays.length; ++i) {
            display = Display(displays.getItemAt(i))
            maxSize.height = Math.max(maxSize.height, display.height)
            maxSize.width = Math.max(maxSize.width, display.width)
          }
          invalidate()
          break
      }
    }

    protected function invalidate():void {
      if (content && maxSize && !maxSize.isEmpty()) {
        if (contentBoundsChanged || !bitmapData ||
            bitmapData.height != maxSize.height ||
            bitmapData.width != maxSize.width) {
          var scale:Number = Math.min(maxSize.width / contentBounds.width,
              maxSize.height / contentBounds.height)
          bitmapData = new BitmapData(contentBounds.width * scale,
              contentBounds.height * scale, true)
          contentTransform = new Matrix(scale, 0, 0, scale,
              -contentBounds.x * scale, -contentBounds.y * scale)
          content.transform.perspectiveProjection.fieldOfView = 55 / Math.PI
          drawBitmap()
        }
      }
      else
        bitmapData = null
      contentBoundsChanged = false
    }
  }
}
