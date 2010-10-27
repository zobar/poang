package {
	import flash.display.DisplayObject
	import flash.display.MovieClip
	import flash.events.Event
	import flash.text.TextField
	import flash.system.Security
	import flash.utils.clearTimeout
	import flash.utils.setTimeout

	public class Sponsors extends MovieClip {
		protected var directory:String
		protected var files:Array
		protected var queue:Array
		protected var scoreboard:*
		protected var timeout:uint

		public function get newFile():* {
			return _newFile
		}

		public function set newFile(value:*):void {
			_newFile = value
			if (newFile && _newSlide is Placeholder)
				Placeholder(_newSlide).source = newFile.url
		}

		private var _newFile:*

		public function get newSlide():DisplayObject {
			return _newSlide
		}

		public function set newSlide(value:DisplayObject):void {
			_newSlide = value
			if (newFile && _newSlide is Placeholder)
				Placeholder(_newSlide).source = newFile.url
		}

		private var _newSlide:DisplayObject

		public function get oldFile():* {
			return _oldFile
		}

		public function set oldFile(value:*):void {
			_oldFile = value
			if (oldFile && _oldSlide is Placeholder)
				Placeholder(_oldSlide).source = oldFile.url
		}

		private var _oldFile:*

		public function get oldSlide():DisplayObject {
			return _oldSlide
		}

		public function set oldSlide(value:DisplayObject):void {
			_oldSlide = value
			if (oldFile && _oldSlide is Placeholder)
				Placeholder(_oldSlide).source = oldFile.url
		}

		private var _oldSlide:DisplayObject

		public function Sponsors() {
			timeout = 0
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage)
			stop()
		}

		public function qcrgInitScoreboard2(scoreboard:*, url:String):void {
			var dirMatch:Object = /^(.*)\.[^.]*$/.exec(url)
			this.scoreboard = scoreboard
			if (dirMatch) {
				directory = dirMatch[1]
				swap()
			}
			else
				scoreboard.status('Could not find directory for ' + loaderInfo.url)
		}

		protected function endTransition():void {
			stop()
			oldFile = newFile
			if (stage)
				timeout = setTimeout(swap, 15000)
			else
				scoreboard.status('Stopping sponsor loop')
		}

		protected function onRemovedFromStage(event:Event):void {
			if (timeout) {
				scoreboard.status('Stopping sponsor loop')
				clearTimeout(timeout)
				timeout = 0
			}
		}

		protected function swap():void {
			if (timeout)
				timeout = 0
			if (!files || !files.length) {
				var listing:Array = scoreboard.getDirectoryListing(directory)
				if (listing) {
					var types:RegExp = /\.(gif|jpg|png|swf)$/i
					files = []
					while (listing.length) {
						var file:* = listing.splice(Math.round(Math.random() * (listing.length - 1)), 1)[0]
						if (types.test(file.url) && file.name.charAt(0) != '.')
							files.push(file)
					}
					scoreboard.status('Found ' + files.length + ' files in ' + directory)
				}
				else {
					scoreboard.status('Could not find ' + directory)
					return
				}
			}
			newFile = files.pop()
			scoreboard.status('Showing ' + newFile.name)
			addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}

		protected function onEnterFrame(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			gotoAndPlay('fade')
		}
	}
}
