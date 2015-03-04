package com.ace.ui.guide
{
	import com.ace.gameData.table.TGuideInfo;
	import com.ace.manager.TimeManager;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.utils.getTimer;

	public class GuideEffectController
	{
		private var display:DisplayObject;
		
		private var tw:TweenMax;
		
		private var _linkInfo:TGuideInfo;
		
		private var remain:int;
		
		private var tick:uint;
		
		private var listenter:Function;
		
		public function GuideEffectController(){
		}
		
		public function get guideInfo():TGuideInfo{
			return _linkInfo;
		}
		
		public function updateInfo(info:TGuideInfo, dis:DisplayObject):void{
			clear();
			display = dis;
			setTimer(info.time);
			_linkInfo = info;
			tw = TweenMax.to(dis, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});
		}
		
		private function setTimer(time:int):void{
			if(time <= 0){
				return;
			}
			remain = time;
			tick = getTimer();
			if(!TimeManager.getInstance().hasITick(onTick)){
				TimeManager.getInstance().addITick(1000, onTick);
			}
		}
		
		protected function onTick():void{
			var inval:int = (getTimer() - tick)/1000;
			if(inval >= remain){
				if(TimeManager.getInstance().hasITick(onTick)){
					TimeManager.getInstance().removeITick(onTick);
				}
				if(null != listenter){
					listenter.call(this, this);
				}
			}
		}
		
		public function clear():void{
			if(null != tw){
				tw.kill();
			}
			if(null != display){
				display.filters = [];
			}
			tw = null;
			display = null;
			listenter = null;
		}
		
		public function setListenter(fun:Function):void{
			listenter = fun;
		}
	}
}