package com.leyou.ui.monsterInvade.child {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenMax;
	import com.leyou.ui.role.child.children.ImgRolling;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Bitmap;

	public class MonsterInvadeRender3 extends AutoWindow {

		private var rollPower:RollNumWidget;

		private var rollArr:Vector.<ImgRolling>
		private var imgArr:Vector.<Image>
		private var bdArr:Array=[];

		private var myexp:String="";

		public function MonsterInvadeRender3() {
			super(LibManager.getInstance().getXML("config/ui/monsterInvade/monsterInvadeRender3.xml"));
			this.init();
			this.clsBtn.visible=false;
			this.hideBg();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=82;
			this.rollPower.y=25;

			this.rollPower.isPopNum=true;
			this.rollPower.popText=PropUtils.getStringById(20);
			this.rollPower.spacing=1;

			this.rollPower.visible=false;

//			this.rollPower.visibleOfBg=false;
//			this.rollPower.alignCenter();

			this.imgArr=new Vector.<Image>;
			this.imgArr.push(new Image("ui/num/0_zdl.png"));
			this.imgArr.push(new Image("ui/num/1_zdl.png"));
			this.imgArr.push(new Image("ui/num/2_zdl.png"));
			this.imgArr.push(new Image("ui/num/3_zdl.png"));
			this.imgArr.push(new Image("ui/num/4_zdl.png"));
			this.imgArr.push(new Image("ui/num/5_zdl.png"));
			this.imgArr.push(new Image("ui/num/6_zdl.png"));
			this.imgArr.push(new Image("ui/num/7_zdl.png"));
			this.imgArr.push(new Image("ui/num/8_zdl.png"));
			this.imgArr.push(new Image("ui/num/9_zdl.png"));

			this.rollArr=new Vector.<ImgRolling>();

			var roll:ImgRolling;
			for (var i:int=0; i < 8; i++) {

				roll=new ImgRolling(i, [new Bitmap(this.imgArr[0].bitmapData), new Bitmap(this.imgArr[1].bitmapData), new Bitmap(this.imgArr[2].bitmapData), new Bitmap(this.imgArr[3].bitmapData), new Bitmap(this.imgArr[4].bitmapData), new Bitmap(this.imgArr[5].bitmapData), new Bitmap(this.imgArr[6].bitmapData), new Bitmap(this.imgArr[7].bitmapData), new Bitmap(this.imgArr[8].bitmapData), new Bitmap(this.imgArr[9].bitmapData)]);

//				roll.endRole=this.imgEnd;

				this.addChild(roll);
				this.rollArr.push(roll);

				roll.setEndImg(new Bitmap(this.imgArr[0].bitmapData));

				roll.y=25;
				roll.x=80 + i * 16;
			}

		}

		public function updateInfo(o:Object):void {

			if (int(this.myexp) == o.myexp)
				return;

			if (this.myexp == "" && o.myexp > 0) {
				this.myexp=o.myexp;
				TweenMax.delayedCall(1, updateRoll);
				return
			}

			this.myexp=o.myexp;
			
			var i:int=0;

			if (o.myexp == 0) {
				for (i=0; i < 8; i++) {
					this.rollArr[i].setEndImg(new Bitmap(this.imgArr[0].bitmapData));
				}
				
				return ;
			}

			var arr:Array=String(o.myexp).split("");
			var st:int=8 - arr.length;
			var delay:Number=1;

			if(st<0)
				return ;
			
			for (i=st; i < 8; i++) {
				this.rollArr[i].startRoll(12);
				TweenMax.delayedCall(delay, updateCallRoll, [i]);
				delay+=0.05;
			}

		}

		private function updateRoll():void {

			var arr:Array=this.myexp.split("");
			var st:int=8 - arr.length;

			for (var i:int=st; i < 8; i++) {

				this.rollArr[i].endRolling(0);
				this.rollArr[i].setEndImg(new Bitmap(this.imgArr[int(arr[i - st])].bitmapData));
			}

		}

		private function updateCallRoll(i:int):void {

			var arr:Array=this.myexp.split("");
			var st:int=8 - arr.length;

			this.rollArr[i].endRolling(0);
			this.rollArr[i].setEndImg(new Bitmap(this.imgArr[int(arr[i - st])].bitmapData));

		}
		
		public function clsHid():void{
			super.hide();
		}
		
		override public function hide():void{
			
		}
	}
}
