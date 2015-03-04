package com.leyou.ui.loading {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class LoadingRen extends AutoSprite {

		private var progressImg:Image;
		private var progressLbl:Label;
		private var progressSwf:SwfLoader;

		private var timer:Timer;
		private var time:Number=0;
		private var type:int=-1;

		private var startTime:int=0;

		private var func:Function;

		public function LoadingRen() {
			super(LibManager.getInstance().getXML("config/ui/loading/LoadingRen.xml"));
			this.init();
			this.hide();
			this.mouseEnabled=this.mouseChildren=false;
		}

		private function init():void {
			this.progressImg=this.getUIbyID("progressImg") as Image;
			this.progressLbl=this.getUIbyID("progressLbl") as Label;
			this.progressSwf=this.getUIbyID("progressSwf") as SwfLoader;

			this.timer=new Timer(20);
			this.timer.addEventListener(TimerEvent.TIMER, onTimer);
//			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}

		public function get running():Boolean {
			return this.timer.running;
		}

		private function onTimer(e:TimerEvent):void {

			var i:Number=int(getTimer() - this.startTime) / this.time;

			this.progressImg.scaleX=i;
			this.progressSwf.x=this.progressImg.x + this.progressImg.width - 20;

			if (i >= 1) {
				if (this.visible)
					this.hide();

				if (func != null)
					func();
			}

		}

		private function onTimerComplete(e:TimerEvent):void {

			if (this.visible)
				this.hide();

			if (func != null)
				func();
		}

		/**
		 * @param t
		 * @param callBack
		 * @param type 0,采集; 1,坐骑
		 */
		public function startProgress(t:Number, callBack:Function, type:int=0):void {
			if (this.visible)
				return;

			this.show();
			this.resize();
			this.type=type;

			this.startTime=getTimer();
			this.time=t;
			this.func=callBack;
			this.progressImg.scaleX=0;
			this.progressSwf.x=this.progressImg.x + this.progressImg.width - 20;

			if (type == 0) {
				this.progressLbl.text="采集中...";
				PlayerEnum.COLLECT_TIME=t;
//				Core.me.info.isCollect=true;
			} else if (type == 1) {
				this.progressLbl.text="骑乘中...";
			}

			this.timer.reset();
			this.timer.start();
		}

		public function getType():int {
			return this.type;
		}

		public function resize():void {
//			this.y=UIEnum.HEIGHT - 200;
//			this.x=(UIEnum.WIDTH - 269) >> 1;
		}

		override public function hide():void {
			super.hide();

			this.timer.stop();
			this.timer.reset();
		}


	}
}
