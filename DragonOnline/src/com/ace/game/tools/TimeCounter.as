package com.ace.game.tools
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 计时器
	 * @author WFH
	 * 
	 */	
	public class TimeCounter
	{
		// 时间戳
		private var tick:uint;
		
		// 额定剩余时间
		private var remianTime:uint;
		
		// 间隔回调函数
		private var delayCall:Function;
		
		// 完成回调函数
		private var onComplete:Function;
		
		// 回调计时间隔
		private var delay:int;
		
		// 计时
		private var timer:Timer;
		
		public function TimeCounter(){
		}
		
		/**
		 * 开始计时(所有单位均用毫秒)
		 *  
		 * @param remain 计时完成时间
		 * @param $delay 计时函数回调间隔
		 * @param update 回调函数
		 * @param complete 计时完成回调
		 * 
		 */		
		public function startCounter(remain:uint, $delay:int=0, update:Function=null, complete:Function=null):void{
			// 时间初始化
			tick = getTimer();
			if(remain > 0){
				remianTime = remain;
			}
			// 回调
			if($delay > 0){
				delayCall = update;
				delay = $delay;
				if(null == timer){
					timer = new Timer($delay);
					timer.addEventListener(TimerEvent.TIMER, onTimer);
				}
				timer.delay = $delay;
				timer.start();
			}
		}
		
		/**
		 * 停止计时
		 * 
		 */		
		public function stopCounter():void{
			if(null != timer){
				timer.stop();
				if(timer.hasEventListener(TimerEvent.TIMER)){
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
				}
				timer = null;
			}
		}
		
		/**
		 * 回调间隔
		 *  
		 * @param event 时间事件
		 * 
		 */		
		protected function onTimer(event:TimerEvent):void{
			if((null != delayCall) && ((remianTime - interval) >= 0)){
				delayCall.call(this, remain);
			}else{
				if(null != onComplete){
					onComplete.call(this);
				}
				stopCounter();
			}
		}
		
		/**
		 * 开始计时到现在的时间间隔
		 *  
		 * @return 时间 
		 * 
		 */		
		public function get interval():int{
			return getTimer() - tick;
		}
		
		/**
		 * 获得剩余时间
		 * 
		 * @return 时间
		 * 
		 */		
		public function get remain():int{
			var r:int = remianTime - interval;
			if(r < 0){
				r = 0;
			}
			return r;
		}
		
		/**
		 * 释放
		 */		
		public function die():void{
			stopCounter();
			delayCall = null;
			onComplete = null;
		}
	}
}