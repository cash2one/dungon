package com.leyou.ui.task {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.leyou.net.cmd.Cmd_Npc;
	
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.utils.Timer;

	public class TaskCollectProgress extends AutoSprite {

		private var progressSc:ScaleBitmap;

		private var timer:Timer;
		private var time:Number=0;

		private var func:Function;

		public function TaskCollectProgress() {
			super(LibManager.getInstance().getXML("config/ui/task/missionProgress.xml"));
			this.init();
//			this.hideBg();
//			this.clsBtn.visible=false;
//			this.allowDrag=false;
			this.hide();
		}

		private function init():void {
			this.progressSc=this.getUIbyID("progress") as ScaleBitmap;

			this.timer=new Timer(100);
			this.timer.addEventListener(TimerEvent.TIMER, onTimer);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}

		private function onTimer(e:TimerEvent):void {
			this.progressSc.scaleX=this.timer.currentCount / this.time;
		}

		private function onTimerComplete(e:TimerEvent):void {

			this.hide();

			if (func != null)
				func();
		}

		/**
		 *
		 * @param t
		 * @param callBack
		 * @param type 0,采集; 1,坐骑
		 *
		 */
		public function startProgress(t:Number, callBack:Function, type:int=0):void {
			if (this.visible)
				return;

			this.show();
			this.resize();

			this.time=t * 1000 / 100;
			this.func=callBack;
			this.progressSc.scaleX=0;

			this.timer.reset();
			this.timer.repeatCount=t * 1000 / 100;
			this.timer.start();
		}
		

		public function resize():void {
			this.y=UIEnum.HEIGHT - 150;
			this.x=(UIEnum.WIDTH - 200) >> 1;
		}

		override public function hide():void {
			super.hide();

			this.timer.stop();
			this.timer.reset();
		}

	}
}
