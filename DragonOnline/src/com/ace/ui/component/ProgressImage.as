package com.ace.ui.component
{
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	
	public class ProgressImage extends Sprite
	{
		private var bg:Image;
		private var cover:Image;
		private var rate:Number;
		private var _loaded:Boolean;
		public var speed:int = 60; // 每秒滚动像素
		public var onComplete:Function;
		
		public function ProgressImage(){
			init();
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}

		public function init():void{
			bg = new Image();
			cover = new Image();
			addChild(bg);
			addChild(cover);
		}
		
		/**
		 * <T>设置资源</T>
		 * 
		 * @param url 图片URL地址
		 * 
		 */		
		public function updateBmp(url:String, $onComplete:Function=null):void{
			_loaded = false;
			bg.updateBmp(url);
			cover.updateBmp(url, onInit);
			onComplete = $onComplete;
		}
		
		/**
		 * <T>加载完成</T>
		 * 
		 */		
		private function onInit():void{
			_loaded = true;
			bg.alpha = 0.3;
			setWHbyRate();
			if(null != onComplete){
				onComplete.call(this);
			}
		}
		
		/**
		 * <T>设置显示长度</T>
		 * <P>以BITMAPDATA的长度为基准</P>
		 * 
		 * @param rate 比值
		 * 
		 */		
		public function setProgress($rate:Number):void{
			if(!loaded || (rate == $rate)){
				rate = $rate;
				setWHbyRate();
				return;
			}
			rate = $rate;
			TweenLite.killTweensOf(bg);
			TweenLite.killTweensOf(cover);
			setWHbyRate();
		}
		
		/**
		 * <T>根据比例设置宽高</T>
		 * 
		 */		
		private function setWHbyRate():void{
			var w:Number = bg.bitmapData.width*rate;
			var h:Number = bg.bitmapData.height;
			bg.setWH(w, h);
			cover.setWH(w, h);
		}
		
		/**
		 * <T>缓慢滚动到一个指定长度</T>
		 * 
		 * @param rate 比值
		 * @param time 缓动时间,若为-1按滚动长度和速度计算缓动时间
		 * 
		 */		
		public function rollToProgress($rate:Number, time:Number=-1, complete:Function=null):void{
			if(!loaded || (rate == $rate)){
				rate = $rate;
				return;
			}
			TweenLite.killTweensOf(bg);
			TweenLite.killTweensOf(cover);
			setWHbyRate();
			var dw:Number;
			var w:Number = bg.bitmapData.width*$rate;
			var h:Number = bg.bitmapData.height;
			if($rate > rate){
				// 变长,背景先动
				bg.setWH(w, h);
				if(-1 == time){
					dw = Math.abs(w - cover.width);
					time = dw / speed;
				}
				TweenLite.to(cover, time, {width:w, ease:Linear.easeNone, onComplete:complete});
			}else{
				// 变短,遮罩先动
				cover.setWH(w, h);
				if(-1 == time){
					dw = Math.abs(w - bg.width);
					time = dw / speed;
				}
				TweenLite.to(bg, time, {width:w, ease:Linear.easeNone, onComplete:complete});
			}
			rate = $rate;
		}
	}
}