package com.leyou.ui.role.child.children {
	
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ImgRolling extends Sprite {
		
		private var flag:int
		private var imgArr:Array;
		private var sp:Sprite;

		public var endRole:Function;
		public var onOverFun:Function;
		public var onOutFun:Function;

		private var img:Image;

		private var scancleFlag:Boolean;

		private var timer:Timer;

		/**
		 *
		 * @param idx
		 * @param arr 滚动的图片
		 * @param f 是否需要缩小图片后显示
		 *
		 */
		public function ImgRolling(idx:int, arr:Array, f:Boolean=false) {
			this.flag=idx;
			this.mouseChildren=false;
//			this.mouseEnabled=false;
			this.imgArr=arr;
			this.scancleFlag=f;
			if (f)
				this.setImg(this.imgArr);
			
			this.init();
		}

		private function init():void {
			this.sp=new Sprite();
			for (var i:int=0; i < this.imgArr.length; i++) {
				
				if (i == 0)
					this.imgArr[i].y=0;
				else
					this.imgArr[i].y=0;

				this.sp.addChild(this.imgArr[i]);
			}

			var mask:Sprite=new Sprite();
			mask.graphics.beginFill(0x000000);
			mask.graphics.drawRect(0, 0, this.imgArr[0].width, this.imgArr[0].height - 6);
			mask.graphics.endFill();

			mask.y=3;

			this.addChild(mask);
			this.sp.mask=mask;

			this.img=new Image();
			this.addChild(img);
			this.img.visible=true;

			this.addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.onOut);

			this.timer=new Timer(20);
			this.timer.addEventListener(TimerEvent.TIMER, onTimer);

		}

		private function changeIdx():void {
			for (var i:int=this.flag; i > 0; i--) {
				this.imgArr.push(this.imgArr.shift());
			}
		}

		public function startRoll(speed:int=16):void {
			this.mouseEnabled=false;
			this.img.visible=false;
			this.sp.visible=true;

			if (this.sp.stage == null || this.sp.parent == null)
				this.addChild(this.sp);

//			if (this.hasEventListener(Event.ENTER_FRAME))
//				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);

			if (this.timer.running)
				this.timer.stop();

			this.speed=speed;
			this.stopIdx=-1;
			this.timer.start();
//			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
//			TweenLite.to(sp, 1, {y: -sp.height, onComplete: rollEnd, ease: Linear.easeNone});
		}

		private var speed:int;
		private var stopIdx:int=-1;

		private function onEnterFrame(evt:Event):void {
//			this.rolling(speed, stopIdx);
		}

		private function onTimer(evt:TimerEvent):void {
			this.rolling(speed, stopIdx);
		}

		public function endRolling(idx:int):void {
			this.speed=speed / 2;
			this.stopIdx=idx;
		}

		private function rolling(speed:int, idx:int=-1):void {

			var i:int=0;
			if (idx >= 0) {
				var yy:Number=this.imgArr[0].y;
//				if (yy > 0 && yy - 10 <= 0) {
					this.imgArr[0].y=-20;
//					this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
					this.timer.stop();

					if (this.endRole != null)
						this.endRole(this.flag);

					return;
//				}
			}

//			trace("==================================", this.height, this.width)

			this.imgArr[0].y-=speed;

			if (this.imgArr[this.imgArr.length - 1].y <=0)
				this.imgArr[0].y=2;

			var f:Boolean;
			for (i=1; i < this.imgArr.length; i++) {
				this.imgArr[i].y=this.imgArr[i - 1].y + this.imgArr[i - 1].height; //*rate;
				
				
//				trace(i, "=|=", this.imgArr[i].y)
//				if (this.imgArr[i].y <= -this.imgArr[i].height) {
//
//					if (i == 0) {
//
//						if (this.imgArr[this.imgArr.length - 1].y < 0)
//							this.imgArr[0].y=this.imgArr[this.imgArr.length - 1].y + this.imgArr[0].height;
////						else
////							this.imgArr[0].y=this.imgArr[0].height;
//
//					} else {
//
//						if (this.imgArr[i - 1].y < 0)
//							this.imgArr[i].y=this.imgArr[i - 1].y + this.imgArr[i].height;
//						else
//							this.imgArr[i].y=this.imgArr[i].height;
//
//					}
//
//					trace(i, "==", this.imgArr[i].y)
//
//				} else {
//
//				}
			}
		}

		private function setImg(arr:Array):void {
			for (var i:int=0; i < arr.length; i++) {
				var scp:ScaleBitmap=new ScaleBitmap((arr[i] as Bitmap).bitmapData);
//				scp.scale9Grid=new Rectangle(3, 3, 44, 44);
//				scp.setSize(64, 64);
				arr[i]=scp;
			}
		}

		public function setEndImg(img:Bitmap, f:Boolean=true):void {
			if (this.contains(this.sp))
				this.removeChild(this.sp);

//				this.img.y=-10;

			if (this.scancleFlag) {
				var arr:Array=[img];
				this.setImg(arr);
				this.img.bitmapData=(arr[0] as ScaleBitmap).bitmapData;
			} else
				this.img.bitmapData=img.bitmapData;

			this.img.visible=true;

			if (f == true) {
				this.img.y=-10;
				TweenLite.to(this.img, .3, {y: 0, ease: Back.easeOut});
			} else
				this.img.y=0;

			this.mouseEnabled=true;
//			for(var i:int=0;i<this.imgArr.length;i++)
//				this.imgArr[i].y=0;
		}

		private function onOver(evt:MouseEvent):void {
			if (this.onOverFun != null)
				this.onOverFun(this.flag);
//			trace("over:"+this.flag);
		}

		private function onOut(evt:MouseEvent):void {
			if (this.onOutFun != null)
				this.onOutFun(this.flag);
//			trace("out:"+this.flag);
		}

	}
}
