package com.ace.ui.component
{
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.img.child.Image;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class ProgressBarII extends SpriteNoEvt
	{
		protected var bg:Image;
		
		protected var maskImg:Image;
		
		protected var progress:Number;
		
		protected var onComplete:Function;
		
		protected var tick:uint;
		
		protected var tickL:uint;
		
		protected var rollTime:uint;
		
		protected var rollDistance:uint;
		
		protected var start:int;
		
		protected var end:int;
		
		public function ProgressBarII(){
			init();
		}
		
		private function init():void{
			bg = new Image();
			maskImg = new Image();
			addChild(bg);
			addChild(maskImg);
		}
		
		public function get loaded():Boolean{
			return maskImg.isLoaded;
		}
		
		public function updateResource(bgUrl:String, maskUrl:String, onComplete:Function):void{
			bg.updateBmp(bgUrl);
			maskImg.updateBmp(maskUrl, onComplete);
		}
		
		public function rollToProgress($progress:Number, time:uint, complete:Function=null):void{
			if($progress <= progress){
				return;
			}
			setProgress(progress);
			tick = getTimer();
			tickL = maskImg.scrollRect.width;
			rollDistance = maskImg.bitmapData.width * (1 - progress);
			rollTime = time*1000;
			progress = $progress;
			onComplete = complete;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function setProgress($progress:Number):void{
			progress = $progress;
			var rect:Rectangle = maskImg.scrollRect;
			if(null == rect){
				rect = new Rectangle(0, 0, maskImg.bitmapData.width, maskImg.bitmapData.height);
			}
			rect.width = start + (maskImg.bitmapData.width - start) * progress;
			maskImg.scrollRect = rect;
		}
		
		private function onEnterFrame(event:Event):void{
			var interval:uint = getTimer() - tick;
			var w:uint = tickL + interval * (rollDistance/rollTime);
			var rect:Rectangle = maskImg.scrollRect;
			rect.width = w;
			maskImg.scrollRect = rect;
		}
		
		public function getRemainTime():int{
			var interval:uint = getTimer() - tick;
			return rollTime - interval;
		}
	}
}