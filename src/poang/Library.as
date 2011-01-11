package poang {
  import dpk.extensionForData
  import flash.display.Bitmap
  import flash.display.BitmapData
  import flash.display.DisplayObject
  import flash.display.Loader
  import flash.display.LoaderInfo
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.filesystem.FileMode
  import flash.filesystem.FileStream
  import flash.net.URLRequest
  import flash.utils.ByteArray
  import flash.utils.getQualifiedClassName
  import mx.collections.ArrayCollection
  import mx.events.CollectionEvent
  import mx.events.CollectionEventKind
  import mx.events.PropertyChangeEvent
  import mx.graphics.codec.PNGEncoder
  import mx.utils.UIDUtil

  [Event(type='complete')]
  public class Library extends Loadable {
    protected static var cache:Object

    protected static var classes:Object = {
      bout:        Bout,
      media:       Media,
      person:      Person,
      preferences: Preferences,
      team:        Team
    };

    protected static function getCache(directory:String, filename:String):* {
      return cache && cache[directory + '/' + filename]
    }

    protected static function setCache(directory:String, filename:String,
        value:*):void {
      var key:String = directory + '/' + filename
      if (!cache)
        cache = {}
      if (!(key in cache))
        cache[key] = value
    }

    [Bindable]
    public function get bout():Bout {
      return _bout
    }
    public function set bout(value:Bout):void {
      if (value != bout) {
        if (bout)
          removeItem(bout)
        _bout = value
        if (bout)
          addItem(bout)
      }
    }
    protected var _bout:Bout

    public function get complete():Boolean {
      return _complete
    }
    protected var _complete:Boolean

    [Bindable]
    public function get media():ArrayCollection {
      return _media
    }
    public function set media(value:ArrayCollection):void {
      if (media) {
        media.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
            onMediaCollectionChange)
      }
      _media = value
      if (media) {
        media.addEventListener(CollectionEvent.COLLECTION_CHANGE,
            onMediaCollectionChange)
      }
    }
    protected var _media:ArrayCollection

    protected var objects:Object
    protected var pending:Array
    protected var pendingLoads:Object
    [Bindable] public var people:ArrayCollection

    public function get preferences():Preferences {
      if (!_preferences) {
        preferences = new Preferences()
        preferences.library = this
      }
      return _preferences
    }
    public function set preferences(value:Preferences):void {
      _preferences = value
    }
    protected var _preferences:Preferences

    [Bindable] public var teams:ArrayCollection

    override protected function set xml(value:XML):void {
      super.xml = value
      if (xml) {
        bout = null
        media = new ArrayCollection()
        objects = {}
        people = new ArrayCollection()
        _preferences = null
        teams = new ArrayCollection()
        for each (var element:XML in xml.children()) {
          var item:LibraryItem = getObject(element.@id, element)
          if (!item.complete) {
            item.addEventListener(Event.COMPLETE, onItemEvent)
            if (!pending)
              pending = []
            pending.push(item)
          }
        }
      }
      _complete = !pending || !pending.length
    }

    public function Library() {
      Poang.app.addEventListener(Event.CLOSE, onApplicationClose)
    }

    public function addItem(item:LibraryItem):void {
      if (!(item.uid in objects))
        objects[item.uid] = item
      if (!xml.*.(@id == item.uid).length())
        xml.appendChild(item.xml)
      if (item.library != this)
        item.library = this
    }

    public function addMedia(value:Media):void {
      if (media.getItemIndex(value) == -1)
        media.addItem(value)
    }

    public function addPerson(person:Person):void {
      if (people.getItemIndex(person) == -1)
        people.addItem(person)
    }

    public function addTeam(team:Team):void {
      if (teams.getItemIndex(team) == -1)
        teams.addItem(team)
    }

    public function findTeam(name:String):Team {
      for (var i:int = 0; i < teams.length; ++i) {
        var team:Team = Team(teams.getItemAt(i))
        if (name == team.name)
          return team
      }
      return null
    }

    public function findMedia(name:String):Media {
      for (var i:int = 0; i < media.length; ++i) {
        var m:Media = Media(media.getItemAt(i))
        if (name == m.name)
          return m
      }
      return null
    }

    public function getObject(uid:String, element:XML=null):LibraryItem {
      var item:LibraryItem = objects[uid]
      var updated:Date
      if (!item) {
        var elements:XMLList = xml.*.(@id == uid)
        if (elements.length)
          element = elements[0]
      }
      if (element) {
        if (!item)
          item = createObject(element)
        if (!item.updated || item.updated.time < Date.parse(element.@updated))
          item.xml = element
        if (item.library != this)
          item.library = this
      }
      return item
    }

    public function newBout():void {
      bout = new Bout()
      bout.homeTeam = findOrCreateTeam(Team.HOME)
      bout.visitorTeam = findOrCreateTeam(Team.VISITOR)
    }

    public function removeItem(item:LibraryItem):void {
      delete xml.*.(@id == item.uid)[0]
    }

    public function removePerson(person:Person):void {
      var index:int = people.getItemIndex(person)
      if (index != -1)
        people.removeItemAt(index)
    }

    internal function getBitmap(filename:String, item:LibraryItem,
        property:String):BitmapData {
      var result:BitmapData = getCache('images', filename)
      if (!result) {
        loadData('images', filename, item, property, onBitmapComplete,
            onBitmapIOError)
      }
      return result
    }

    internal function getMedia(filename:String, item:LibraryItem,
        property:String):DisplayObject {
      var result:DisplayObject = getCache('media', filename)
      if (!result) {
        loadData('media', filename, item, property, onMediaComplete,
            onMediaIOError)
      }
      return result
    }

    internal function setBitmap(uid:String, bitmap:BitmapData,
        data:ByteArray=null):String {
      var filename:String = uid
      if (!data)
        data = new PNGEncoder().encode(bitmap)
      filename += dpk.extensionForData(data)
      setCache('images', filename, bitmap)
      setData('images', filename, data)
      return filename
    }

    internal function setData(directory:String, filename:String,
        data:ByteArray):void {
      var dir:File = file.parent.resolvePath(directory)
      var f:File
      if (!dir.exists)
        dir.createDirectory()
      f = dir.resolvePath(filename)
      if (!f.exists) {
        var stream:FileStream = new FileStream()
        stream.open(f, FileMode.WRITE)
        stream.writeBytes(data)
        stream.close()
      }
    }

    internal function setMedia(filename:String, displayObject:DisplayObject,
        data:ByteArray=null):String {
      var external:Boolean = UIDUtil.isUID(filename)
      if (!data)
        data = displayObject.loaderInfo.bytes
      filename += dpk.extensionForData(data)
      setCache('media', filename, displayObject)
      if (external)
        setData('media', filename, data)
      return filename
    }

    protected function createObject(element:XML):LibraryItem {
      var class_:Class = classes[element.name()]
      var item:LibraryItem = new class_()
      objects[item.uid] = item
      return item
    }

    protected function findOrCreateTeam(name:String):Team {
      var result:Team = findTeam(name)
      if (!result) {
        result = new Team()
        result.name = name
        result.library = this
      }
      return result
    }

    protected function loadData(directory:String, filename:String,
        item:LibraryItem, property:String, completeHandler:Function,
        ioErrorHandler:Function):void {
      var f:File
      for each (var parent:File in [File.applicationDirectory, file.parent]) {
        f = parent.resolvePath(directory).resolvePath(filename)
        if (f.exists)
          break
      }
      if (f.exists) {
        var pending:Object
        if (!pendingLoads)
          pendingLoads = {}
        pending = pendingLoads[filename]
        if (pending) {
          var properties:Array = pending[item.uid]
          if (properties) {
            if (properties.indexOf(property) == -1)
              properties.push(property)
          }
          else
            pending[item.uid] = [property]
        }
        else {
          var loader:Loader = new Loader()
          loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
              completeHandler)
          loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
              ioErrorHandler)
          pendingLoads[filename] = pending = {}
          pending[item.uid] = [property]
          loader.load(new URLRequest(f.url))
        }
      }
    }

    protected function notifyPending(filename:String, value:*):void {
      var pending:Object = pendingLoads[filename]
      for (var uid:String in pending) {
        var item:LibraryItem = getObject(uid)
        for each (var property:String in pending[uid]) {
          item.dispatchEvent(PropertyChangeEvent.createUpdateEvent(item,
              property, null, value))
        }
      }
      delete pendingLoads[filename]
    }

    protected function onApplicationClose(event:Event):void {
      var stream:FileStream = new FileStream()
      Poang.app.removeEventListener(Event.CLOSE, onApplicationClose)
      trace(xml)
      stream.open(file, FileMode.WRITE)
      stream.writeUTFBytes(xml.toXMLString())
      stream.close()
    }

    protected function onBitmapComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var content:DisplayObject = loaderInfo.content
      loaderInfo.removeEventListener(Event.COMPLETE, onBitmapComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBitmapIOError)
      if (content is Bitmap) {
        var bitmapData:BitmapData = Bitmap(content).bitmapData
        var filename:String =
            decodeURIComponent(loaderInfo.url.match(/[^\/]*$/)[0])
        setCache('images', filename, bitmapData)
        notifyPending(filename, bitmapData)
      }
    }

    protected function onBitmapIOError(event:IOErrorEvent):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var filename:String =
          decodeURIComponent(loaderInfo.url.match(/[^\/]*$/)[0])
      loaderInfo.removeEventListener(Event.COMPLETE, onBitmapComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBitmapIOError)
      delete pendingLoads[filename]
    }

    override protected function onFileComplete(event:Event):void {
      xml = XML(File(event.currentTarget).data)
      if (complete)
        dispatchEvent(new Event(Event.COMPLETE))
    }

    protected function onItemEvent(event:Event):void {
      var item:LibraryItem = LibraryItem(event.currentTarget)
      var index:int = pending.indexOf(item)
      item.removeEventListener(Event.COMPLETE, onItemEvent)
      item.removeEventListener(IOErrorEvent.IO_ERROR, onItemEvent)
      if (index != -1) {
        pending.splice(index, 1)
        _complete = !pending.length
        if (complete)
          dispatchEvent(new Event(Event.COMPLETE))
      }
    }

    protected function
        onMediaCollectionChange(event:CollectionEvent):void {
      var changeEvent:PropertyChangeEvent
      var cursor:XML
      var i:int
      var item:Media
      switch (event.kind) {
        case CollectionEventKind.ADD:
          cursor = xml.media[event.location - 1][0]
          for each (item in event.items) {
            // We need to remove the item so that we can re-insert it in the
            // right place.
            removeItem(item)
            cursor = xml.insertChildAfter(cursor, item.xml)
          }
          break
        case CollectionEventKind.REMOVE:
          for each (item in event.items)
            delete xml.media[event.location]
          break
        case CollectionEventKind.REPLACE:
          i = event.location
          for each (changeEvent in event.items) {
            item = Media(changeEvent.newValue)
            xml.media[i++] = item.xml
          }
          break
        case CollectionEventKind.RESET:
          i = xml.media.length
          while (i)
            delete xml.media[--i]
          for (i = 0; i < event.currentTarget.length; ++i) {
            item = event.currentTarget.getItemAt(i)
            xml.media += item.xml
          }
          break
      }
    }

    protected function onMediaComplete(event:Event):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var content:DisplayObject = loaderInfo.content
      var filename:String =
          decodeURIComponent(loaderInfo.url.match(/[^\/]*$/)[0])
      loaderInfo.removeEventListener(Event.COMPLETE, onMediaComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onMediaIOError)
      setCache('media', filename, content)
      notifyPending(filename, content)
    }

    protected function onMediaIOError(event:IOErrorEvent):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      var filename:String =
          decodeURIComponent(loaderInfo.url.match(/[^\/]*$/)[0])
      loaderInfo.removeEventListener(Event.COMPLETE, onMediaComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onMediaIOError)
      delete pendingLoads[filename]
    }
  }
}
