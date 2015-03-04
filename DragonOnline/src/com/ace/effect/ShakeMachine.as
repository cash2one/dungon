package com.ace.effect {
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 震动触发器
	 * @author wfh
	 *
	 */
	public class ShakeMachine {
		// 目标对象
		private var display:DisplayObject;

		// 震动范围
		private var shakeRange:int;

		// 当前震动梯次
		private var shakeDirecting:int;

		// 起始震动时间戳
		private var tick:Number;

		// 震动时间
		private var time:uint;

		// 震动次数
		private var frequency:int;

		// 当前震动次数
		private var current:int;

		// 震动计时器
		private var shakeTimer:Timer=new Timer(100);

		// 是否可用
		public var free:Boolean=true;

		public function ShakeMachine() {
		}

		/**
		 * <T>震动效果</T>
		 *
		 * @param $display 目标对象
		 * @param $range   震动幅度
		 * @param $time    总震动时间
		 * @param $frequency 总震动次数
		 *
		 */
		public function startShake($display:DisplayObject, $range:int, $time:uint, $frequency:int=1):void {
			time=$time;
			display=$display;
			shakeRange=$range;
			frequency=$frequency;
			shakeTimer.delay=$time / $frequency / 4;
			shakeTimer.addEventListener(TimerEvent.TIMER, shake);
			shakeTimer.start();
			free=false;
		}

		/**
		 * <T>震动</T>
		 *
		 * @param event 震动事件
		 *
		 */
		private function shake(event:TimerEvent):void {
			switch(shakeDirecting){
				case 0:
					display.x += shakeRange;
					shakeDirecting++;
					break;
				case 1:
					display.y += shakeRange;
					shakeDirecting++;
					break;
				case 2:
					display.x -= shakeRange;
					shakeDirecting++;
					break;
				case 3:
					display.y -= shakeRange;
					shakeDirecting = 0;
					if(++current >= frequency){
						free = true;
						display = null;
						shakeTimer.stop();
						shakeTimer.removeEventListener(TimerEvent.TIMER, shake);
					}
					break;
			}
		}

		/**
		 * <T>周期结束</T>
		 *
		 */
		public function die():void {
			display=null;
			shakeTimer=null;
		}
	}
}