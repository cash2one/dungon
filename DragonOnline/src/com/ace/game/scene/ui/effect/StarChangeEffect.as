package com.ace.game.scene.ui.effect {

	import com.ace.ui.img.child.Image;
	import com.greensock.TweenMax;

	import flash.display.Sprite;
	import flash.geom.Point;

	public class StarChangeEffect extends Sprite {


		private var starArr:Vector.<Image>;

		private var count:int=0;
		private var ischange:Boolean=false;
		private var changeIndex:int=-2;
		private var radioIndex:int=0;

		private var tweenMax:TweenMax;

		public function StarChangeEffect(num:int=10, change:Boolean=false, radio:int=0) {
			super();
			this.count=num;
			this.ischange=change;
			this.radioIndex=radio;
			this.init();
		}

		private function init():void {

			this.starArr=new Vector.<Image>();

			var space:int=20;
			var angleSpace:Number=Math.asin(space / this.radioIndex) * 180 / Math.PI;
			var sp:int=0;

			if (this.count % 2 == 0)
				sp=270 - int(this.count / 2 - 1) * angleSpace - angleSpace / 2;
			else
				sp=270 - int(this.count / 2) * angleSpace;

			var tSpace:Number=0;
			var img:Image;
			for (var i:int=0; i < this.count; i++) {

				img=new Image("ui/equip/equip_star.png");
				this.addChild(img);

				if (this.radioIndex == 0) {
					img.x=i * space;
				} else {

					tSpace=(sp + i * angleSpace) * Math.PI / 180;

					img.x=Math.cos(tSpace) * this.radioIndex + this.radioIndex;
					img.y=Math.sin(tSpace) * this.radioIndex + this.radioIndex;
				}

				this.starArr.push(img);
			}

		}

		public function setStarPos(i:int):void {

			if (i == this.changeIndex)
				return;

			if (tweenMax != null) {
				tweenMax.pause();
				tweenMax.kill();
				tweenMax=null;
			}

			for (var j:int=0; j < this.starArr.length; j++) {

				this.starArr[j].alpha=1;

				if (j <= i) {
					this.starArr[j].updateBmp("ui/equip/equip_star.png");
				} else if (this.ischange && j == i + 1) {
					this.starArr[j].updateBmp("ui/equip/equip_star.png");
					tweenMax=TweenMax.to(this.starArr[j], 1, {alpha: 0, repeat: -1, yoyo: true});
					this.changeIndex=i;
				} else {
					this.starArr[j].updateBmp("ui/equip/equip_star2.png");
				}

			}

			if (i == 9)
				this.changeIndex=-2;

		}




	}
}
