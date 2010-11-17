package dpk {
  import flash.desktop.NativeApplication
  import flash.desktop.Updater
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.events.IOErrorEvent
  import flash.filesystem.File
  import flash.net.URLLoader
  import flash.net.URLRequest
  import mx.collections.ArrayCollection

  [Event(name='complete')]
  [Event(name='downloadStarted', type='dpk.UpdateEvent')]
  [Event(name='ioError', type='flash.events.IOErrorEvent')]
  [Event(name='select')]
  [Event(name='updateAvailable', type='dpk.UpdateEvent')]
  public class GithubUpdater extends EventDispatcher {
    protected static const GITHUB_BASE:String = 'http://github.com/'
    protected static const API_BASE:String = GITHUB_BASE + 'api/v2/xml/';

    [Bindable]
    public function get branch():String {
      return _branch
    }
    public function set branch(value:String):void {
      _branch = value
    }
    protected var _branch:String

    [Bindable]
    public function get branches():ArrayCollection {
      if (!_branches) {
        _branches = new ArrayCollection()
        if (branch)
          _branches.addItem(branch)
        new URLLoaderHelper(API_BASE + 'repos/show/' + user + '/' + repository
            + '/branches', onBranchLoaderComplete)
      }
      return _branches
    }
    public function set branches(value:ArrayCollection):void {
      _branches = value
    }
    protected var _branches:ArrayCollection

    public function get branchURL():String {
      return GITHUB_BASE + user + '/' + repository + '/raw/' + branch
    }

    public function get complete():Boolean {
      return _complete
    }
    protected var _complete:Boolean

    public function get file():File {
      return _file
    }
    protected var _file:File

    public function get path():String {
      return _path
    }
    protected var _path:String

    public function get repository():String {
      return _repository
    }
    protected var _repository:String

    public function get updateInfo():XML {
      return _updateInfo
    }
    protected var _updateInfo:XML

    public function get user():String {
      return _user
    }
    protected var _user:String

    public function GithubUpdater(user:String, repository:String,
        path:String):void {
      _path = path
      _repository = repository
      _user = user
    }

    public function check():void {
      if (complete)
        dispatchEvent(new Event(Event.COMPLETE))
      else if (!file)
        new URLLoaderHelper(branchURL + '/' + path, onVersionLoaderComplete)
    }

    public function download():void {
      if (!_file) {
        var location:String = updateInfo.location
        _file = new File()
        file.addEventListener(Event.CANCEL, onFileCancel)
        file.addEventListener(Event.COMPLETE, onFileComplete)
        file.addEventListener(IOErrorEvent.IO_ERROR, onFileIOError)
        file.addEventListener(Event.SELECT, onFileSelect)
        file.download(new URLRequest(branchURL + '/' + location),
            location.match(/[^\/]*$/)[0])
      }
    }

    public function update():void {
      new Updater().update(file, updateInfo.version)
    }

    protected function onBranchLoaderComplete(event:Event):void {
      var branchNames:Array = []
      var loader:URLLoader = URLLoader(event.currentTarget)
      var data:XML = XML(loader.data)
      for each (var branch:XML in XML(loader.data).children())
        branchNames.push(branch.name().toString())
      branches.source = branchNames
    }

    protected function onFileCancel(event:Event):void {
      dispatchEvent(event)
      removeFileEventListeners()
      _file = null
    }

    protected function onFileComplete(event:Event):void {
      _complete = true
      dispatchEvent(event)
      removeFileEventListeners()
    }

    protected function onFileIOError(event:IOErrorEvent):void {
      dispatchEvent(event)
      removeFileEventListeners()
      _file = null
    }

    protected function onFileSelect(event:Event):void {
      dispatchEvent(new UpdateEvent(UpdateEvent.DOWNLOAD_STARTED))
    }

    protected function onVersionLoaderComplete(event:Event):void {
      var descriptor:XML =
          NativeApplication.nativeApplication.applicationDescriptor
      var loader:URLLoader = URLLoader(event.currentTarget)
      var namespace:Namespace = descriptor.namespace()
      _updateInfo = XML(loader.data)
      if (updateInfo.version.toString() !=
          descriptor.namespace::versionNumber.toString())
        dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE_AVAILABLE))
    }

    protected function removeFileEventListeners():void {
      file.removeEventListener(Event.CANCEL, onFileCancel)
      file.removeEventListener(Event.COMPLETE, onFileComplete)
      file.removeEventListener(IOErrorEvent.IO_ERROR, onFileIOError)
      file.removeEventListener(Event.SELECT, onFileSelect)
    }
  }
}
