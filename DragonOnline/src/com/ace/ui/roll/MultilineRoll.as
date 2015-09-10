package com.ace.ui.roll {


	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class MultilineRoll extends Sprite {


		private var imgBdArr:Vector.<BitmapData>;
		private var imgArr:Vector.<Bitmap>;

		private var lineNum:int=1;

		private var currentArr:Vector.<Bitmap>;
		private var currentIndex:int=0;

		private var currentendIndex:int=-1;

		private var currentSpace:int=0;

		private var singleHeight:Number=0;

		private var endIndex:int=-1;

		private var timer:Timer;
		private var delay:Number=0;

		private var startTime:Number=0;

		public function MultilineRoll(img:Vector.<BitmapData>, line:int=1) {
			super();
			this.imgBdArr=img;
			this.lineNum=line;

			this.init();
		}

		private function init():void {

			this.timer=new Timer(20);
			this.timer.addEventListener(TimerEvent.TIMER, onTimer);

			this.imgArr=new Vector.<Bitmap>();
			this.currentArr=new Vector.<Bitmap>();

			for (var i:int=0; i < this.imgBdArr.length; i++) {
				this.imgArr.push(new Bitmap(this.imgBdArr[i]));
			}

			this.singleHeight=this.imgBdArr[i - 1].height;

			this.setPos();

			this.scrollRect=new Rectangle(0, 0, this.imgBdArr[i - 1].width, this.imgBdArr[i - 1].height * this.lineNum);
		}

		public function setup(delay:Number=3000, speed:int=20):void {

			this.delay=delay + speed / 20;
			this.endIndex=-1;
			this.currentSpace=0;
			this.currentendIndex=-1;
			this.startTime=getTimer();

			this.timer.delay=speed;
			this.timer.start();

		}

		private function onComplete():void {


		}

		private function onTimer(e:TimerEvent):void {

			var dtime:int=getTimer();
			if (dtime - this.startTime <= this.delay / 2) {
				this.currentSpace++;
			} else {
				this.currentSpace--;
			}

			if (this.currentSpace >= 65)
				this.currentSpace=65;
			else if (this.currentSpace <= 1)
				this.currentSpace=1;

//			if (this.endIndex == -1 && dtime - this.startTime > this.delay) {
//
//				if (this.currentendIndex == -1)
//					this.currentendIndex=this.currentIndex;
//
//				if (this.currentArr[(this.currentendIndex + 1) % this.currentArr.length].y == 0) {
//					this.stop();
//					this.currentSpace=0;
//				}
//			}

			this.updatePosition();
		}

		private function updatePosition():void {

			var cidx:int=0;
			for (var i:int=0; i < this.currentArr.length; i++) {
				this.currentArr[i].y-=this.currentSpace;

				if (this.currentArr[i].y <= -this.singleHeight) {
					cidx++;
				}
			}


			if (cidx > 0) {


				if (this.endIndex == (this.currentIndex) % this.imgArr.length) {
					this.stop();

					for (i=0; i < this.currentArr.length; i++) {
						TweenLite.to(this.currentArr[i], 0.2, {y: i * this.singleHeight})
					}
				} else {

					var bd:Bitmap=this.currentArr.shift();
					bd.bitmapData=this.imgArr[(this.currentIndex + 4) % this.imgArr.length].bitmapData;

					bd.y=this.currentArr[this.currentArr.length - 1].y + this.singleHeight;

					this.currentArr.push(bd);

					this.currentIndex++;

					if (this.currentIndex >= this.imgArr.length) {
						this.currentIndex=this.currentIndex % this.imgArr.length;
					}
				}
			}

		}

		public function endRoll(pos:int=-1):void {
//			this.stop();
//			trace("end",pos)
			this.endIndex=pos;
		}

		public function setPos(_i:int=0):void {

			var pos:int=_i - 1;
			var i:int=0;
			var bd:Bitmap;
			for (i=0; i < this.lineNum + 2; i++) {

				bd=new Bitmap(this.imgArr[(this.imgArr.length + pos) % this.imgArr.length].bitmapData);

				this.currentArr.push(bd);
				this.addChild(bd);

				bd.y=(i) * this.singleHeight;

				pos++;
			}

			this.currentIndex=_i;
		}

		private function stop():void {
			this.timer.stop();
			this.timer.reset();


		}

	}
}
