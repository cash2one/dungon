package com.leyou.data.effect {


	import com.ace.enum.UIEnum;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class MovieClipLoader extends Sprite {

		private var _mc:MovieClip;

		private var _loader:Loader;

		public function MovieClipLoader(url:String) {
			this.init();
			this.updateLoader(url);
		}

		private function init():void {
			this._loader=new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}

		public function updateLoader(url:String):void {
			this._loader.load(new URLRequest(UIEnum.DATAROOT + url));
		}


		private function onComplete(e:Event):void {
			_mc=e.target.content;
			if (_mc != null) {
				if (this.numChildren > 0)
					this.removeChildAt(0);

				this.addChild(_mc);
			}
		}


		public function get mc():MovieClip {
			return _mc;
		}
	}
}
