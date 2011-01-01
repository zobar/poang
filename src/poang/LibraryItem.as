package poang {
  import flash.display.BitmapData
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.events.IOErrorEvent
  import flash.geom.Rectangle
  import flash.utils.ByteArray
  import flash.utils.getQualifiedClassName
  import mx.collections.ArrayCollection
  import mx.core.IUID
  import mx.events.CollectionEvent
  import mx.events.CollectionEventKind
  import mx.events.PropertyChangeEvent
  import mx.utils.UIDUtil

  [Event(type='complete')]
  public class LibraryItem extends EventDispatcher implements IUID {
    public function get complete():Boolean {
      return _complete
    }
    protected var _complete:Boolean

    internal function get library():Library {
      return _library
    }
    internal function set library(value:Library):void {
      _library = value
      if (library)
        library.addItem(this)
    }
    protected var _library:Library

    protected var objectLists:Object
    protected var pending:Array

    public function get uid():String {
      return getString('@id')
    }

    public function set uid(value:String):void {
      xml.@id = value
    }

    public function get updated():Date {
      return getDate('@updated')
    }

    public function get xml():XML {
      return _xml
    }
    public function set xml(value:XML):void {
      _xml = value
      _complete = !pending || !pending.length
      if (complete)
        dispatchEvent(new Event(Event.COMPLETE))
    }
    protected var _xml:XML

    public function LibraryItem() {
      xml = <{getQualifiedClassName(this).match(/[^:]*$/)[0].toLowerCase()}/>
      uid = UIDUtil.createUID()
    }

    override public function toString():String {
      return '[' + getQualifiedClassName(this) + ' ' + uid + ']'
    }

    protected function findOrCreateObject(class_:Class,
        uid:String):LibraryItem {
      var result:LibraryItem = library.getObject(uid)
      if (!result) {
        result = new class_()
        result.uid = uid
        result.library = library
      }
      return result
    }

    protected function getBitmap(key:String):BitmapData {
      var filename:String = getString(key)
      return filename ? library.getBitmap(filename, this, key) : null
    }

    protected function getBoolean(key:String,
        defaultValue:Boolean=false):Boolean {
      if (hasValue(key))
        return xml[key].toString() == 'true'
      return defaultValue
    }

    protected function getDate(key:String):Date {
      var result:Date
      if (hasValue(key))
        result = new Date(Date.parse(getString(key)))
      return result
    }

    protected function getInt(key:String, defaultValue:int=0):int {
      if (hasValue(key))
        return parseInt(xml[key])
      return defaultValue
    }

    protected function getIntArray(key:String):Array {
      var result:Array
      if (hasValue(key)) {
        var parts:Array = getString(key).split(/\s+/)
        result = []
        for each (var part:String in parts)
          result.push(parseInt(part))
      }
      return result
    }

    protected function getObject(class_:Class, key:String):* {
      var uid:String = getString(key)
      var result:*
      if (uid)
        result = findOrCreateObject(class_, uid)
      return result
    }

    protected function getObjectList(class_:Class, key:String):ArrayCollection {
      var result:ArrayCollection
      if (!objectLists)
        objectLists = {}
      result = objectLists[key]
      if (!result) {
        result = objectLists[key] = new ArrayCollection()
        for each (var element:XML in xml[key]) {
          result.addItem(findOrCreateObject(class_, element))
        }
        result.addEventListener(CollectionEvent.COLLECTION_CHANGE,
            onObjectListCollectionChange)
      }
      return result
    }

    protected function getRectangle(key:String):Rectangle {
      var result:Rectangle
      if (hasValue(key)) {
        var parts:Array = getString(key).split(/\s+/, 4)
        result = new Rectangle(parseFloat(parts[0]), parseFloat(parts[1]),
            parseFloat(parts[2]), parseFloat(parts[3]))
      }
      return result
    }

    protected function getString(key:String, defaultValue:String=null):String {
      if (hasValue(key))
        return xml[key].toString()
      return defaultValue
    }

    protected function hasValue(key:String):Boolean {
      return xml && xml.hasOwnProperty(key)
    }

    protected function load(loadable:Loadable, url:String):void {
      if (!pending)
        pending = []
      pending.push(loadable)
      loadable.addEventListener(Event.COMPLETE, onLoadableEvent)
      loadable.addEventListener(IOErrorEvent.IO_ERROR, onLoadableEvent)
      loadable.load(url)
    }

    protected function onLoadableEvent(event:Event):void {
      var loadable:Loadable = Loadable(event.currentTarget)
      var index:int = pending.indexOf(loadable)
      loadable.removeEventListener(Event.COMPLETE, onLoadableEvent)
      loadable.removeEventListener(IOErrorEvent.IO_ERROR, onLoadableEvent)
      if (index != -1) {
        pending.splice(index, 1)
        _complete = !pending.length
        if (complete)
          dispatchEvent(new Event(Event.COMPLETE))
      }
    }

    protected function
        onObjectListCollectionChange(event:CollectionEvent):void {
      var key:String
      var objectList:ArrayCollection = ArrayCollection(event.currentTarget)
      for (var k:String in objectLists) {
        if (objectLists[k] == objectList) {
          key = k
          break
        }
      }
      if (key) {
        var changeEvent:PropertyChangeEvent
        var cursor:XML
        var i:int
        var item:LibraryItem
        switch (event.kind) {
          case CollectionEventKind.ADD:
            cursor = xml[key][event.location - 1][0]
            for each (item in event.items) {
              item.library = library
              cursor = xml.insertChildAfter(cursor, <{key}>{item.uid}</{key}>)
            }
            break
          case CollectionEventKind.REMOVE:
            for each (item in event.items) {
              if (!item.updated)
                library.removeItem(item)
              delete xml[key][event.location]
            }
            break
          case CollectionEventKind.REPLACE:
            i = event.location
            for each (changeEvent in event.items) {
              item = LibraryItem(changeEvent.oldValue)
              if (!item.updated)
                library.removeItem(item)
              item = LibraryItem(changeEvent.newValue)
              item.library = library
              xml[key][i++] = item.uid
            }
            break
          case CollectionEventKind.RESET:
            i = xml[key].length
            while (i)
              delete xml[key][--i]
            for (i = 0; i < event.currentTarget.length; ++i) {
              item = event.currentTarget.getItemAt(i)
              item.library = library
              xml[key] += item.uid
            }
            break
        }
      }
    }

    protected function setBitmap(key:String, bitmap:BitmapData,
        data:ByteArray=null):void {
      if (bitmap) {
        var uid:String = UIDUtil.getUID(bitmap)
        var oldValue:BitmapData = data ? getBitmap(key) : null
        setString(key, library.setBitmap(uid, bitmap, data))
        if (data) {
          dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, key,
              oldValue, bitmap))
        }
      }
      else
        setString(key, null)
    }

    protected function setBoolean(key:String, value:Boolean,
        defaultValue:Boolean):void {
      setString(key, value.toString(), defaultValue.toString())
    }

    protected function setDate(key:String, value:Date):void {
      if (value)
        setString(key, value.toUTCString())
      else
        setString(key, null)
    }

    protected function setInt(key:String, value:int, defaultValue:int):void {
      setString(key, value.toString(), defaultValue.toString())
    }

    protected function setIntArray(key:String, value:Array):void {
      if (value)
        setString(key, value.join(' '))
      else
        setString(key, null)
    }

    protected function setObject(key:String, value:LibraryItem):void {
      if (value) {
        library.addItem(value)
        setString(key, value.uid)
      }
      else
        setString(key, null)
    }

    protected function setObjectList(key:String, value:ArrayCollection):void {
      var i:int
      var item:LibraryItem
      var old:ArrayCollection
      if (!objectLists)
        objectLists = {}
      old = objectLists[key]
      if (old) {
        old.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
            onObjectListCollectionChange)
        delete xml[key]
      }
      objectLists[key] = value
      if (value) {
        for (i = 0; i < value.length; ++i) {
          item = LibraryItem(value.getItemAt(i))
          xml[key] += item.uid
        }
      }
    }

    protected function setRectangle(key:String, value:Rectangle):void {
      if (value) {
        setString(key, value.x + ' ' + value.y + ' ' + value.width + ' ' +
            value.height)
      }
      else
        setString(key, null)
    }

    protected function setString(key:String, value:String,
        defaultValue:String=null):void {
      if (value != getString(key, defaultValue)) {
        if (value == null || value == defaultValue)
          delete xml[key]
        else
          xml[key] = value
        if (key != '@updated')
          setDate('@updated', new Date())
      }
    }
  }
}
