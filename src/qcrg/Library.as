package qcrg {
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
  import mx.events.PropertyChangeEvent
  import mx.graphics.codec.PNGEncoder

  [Event(type='complete')]
  public class Library extends Loadable {
    protected static var bitmapCache:Object

    protected static var classes:Object = {
      bout:        Bout,
      person:      Person,
      preferences: Preferences,
      team:        Team
    };

    [Bindable]
    public function get bout():Bout {
      return _bout
    }
    public function set bout(value:Bout):void {
      trace('setting bout to ' + value)
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

    override protected function set file(value:File):void {
      super.file = value
      images = file.parent.resolvePath('images')
    }

    protected var images:File
    protected var objects:Object
    protected var pending:Array
    protected var pendingBitmaps:Object
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
      QCRGScoreboard.app.addEventListener(Event.CLOSE, onApplicationClose)
    }

    public function addItem(item:LibraryItem):void {
      if (!(item.uid in objects))
        objects[item.uid] = item
      if (!xml.*.(@id == item.uid).length())
        xml.appendChild(item.xml)
      if (item.library != this)
        item.library = this
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

    public function getObject(uid:String, element:XML=null):LibraryItem {
      var item:LibraryItem = objects[uid]
      var updated:Date
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
      var result:BitmapData
      if (bitmapCache && (filename in bitmapCache))
        result = bitmapCache[filename]
      else {
        var file:File = images.resolvePath(filename)
        if (file.exists) {
          var pending:Object
          if (!pendingBitmaps)
            pendingBitmaps = {}
          pending = pendingBitmaps[filename]
          if (pending) {
            var properties:Array = pending[item.uid]
            if (properties) {
              if (properties.indexOf(property) == -1)
                properties.push(property)
            }
            else
              pending[item.uid] = [property]
          }
          if (!pending) {
            var loader:Loader = new Loader()
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
                onBitmapComplete)
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
                onBitmapIOError)
            pendingBitmaps[filename] = pending = {}
            pending[item.uid] = [property]
            loader.load(new URLRequest(file.url))
          }
        }
      }
      return result
    }

    internal function setBitmap(uid:String, bitmap:BitmapData,
        data:ByteArray=null):String {
      var file:File
      var filename:String = uid

      if (!data)
        data = new PNGEncoder().encode(bitmap)
      switch (data[0]) {
        case 0x46:
          filename += '.swf'
          break
        case 0x47:
          filename += '.gif'
          break
        case 0x89:
          filename += '.png'
          break
        case 0xff:
          filename += '.jpg'
          break
      }

      cacheBitmap(filename, bitmap)

      if (!images.exists)
        images.createDirectory()
      file = images.resolvePath(filename)
      if (!file.exists) {
        var stream:FileStream = new FileStream()
        stream.open(file, FileMode.WRITE)
        stream.writeBytes(data)
        stream.close()
      }

      return filename
    }

    protected function cacheBitmap(filename:String, bitmap:BitmapData):void {
      if (!bitmapCache)
        bitmapCache = {}
      if (!(filename in bitmapCache))
        bitmapCache[filename] = bitmap
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

    protected function onApplicationClose(event:Event):void {
      var stream:FileStream = new FileStream()
      QCRGScoreboard.app.removeEventListener(Event.CLOSE, onApplicationClose)
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
        var filename:String = loaderInfo.url.match(/[^\/]*$/)[0]
        var pending:Object = pendingBitmaps[filename]
        cacheBitmap(filename, bitmapData)
        for (var uid:String in pending) {
          var item:LibraryItem = getObject(uid)
          for each (var property:String in pending[uid]) {
            item.dispatchEvent(PropertyChangeEvent.createUpdateEvent(item,
                property, null, bitmapData))
          }
        }
      }
    }

    protected function onBitmapIOError(event:IOErrorEvent):void {
      var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget)
      loaderInfo.removeEventListener(Event.COMPLETE, onBitmapComplete)
      loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBitmapIOError)
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
  }
}
