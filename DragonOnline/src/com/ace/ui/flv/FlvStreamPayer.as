package com.ace.ui.flv {
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class FlvStreamPayer extends Sprite {

		private var video:Video;
		private var stm:NetStream;

		public function FlvStreamPayer() {

			this.init();
		}

		private function init():void {

			var conn:NetConnection=new NetConnection();
			conn.connect(null);

			stm=new NetStream(conn);
			var obj:Object=new Object();
			obj.onMetaData = metaDataHandller;
			stm.client=obj;

			video=new Video();
			video.attachNetStream(stm);
			this.addChild(video);

			stm.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
		}
		
		private function metaDataHandller(info:Object):void {
			 video.width=info.width;
			 video.height=info.height;
		}

		private function onStatus(e:NetStatusEvent):void {
			if (e.info.code == "NetStream.Play.Stop") {
				stm.seek(0);
			}
		}

		public function play(url:String):void {
			this.stm.play(url);
		}

		public function setVideoWidth(w:int):void {
			this.video.width=w;
		}

		public function setVideoHeight(h:int):void {
			this.video.height=h;
		}

	}
}
