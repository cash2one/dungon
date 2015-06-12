package com.leyou.ui.day7.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.utils.FilterUtil;

	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	public class SdayPic extends AutoSprite {

		private var bgImg:Image;
		private var stateImg:Image;

		private var colorSwf:Sprite;

		public function SdayPic() {
			super(LibManager.getInstance().getXML("config/ui/7day/sdayPic.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {

			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.stateImg=this.getUIbyID("stateImg") as Image;

			this.colorSwf=new Sprite();
//			this.addChild(this.colorSwf);

			this.colorSwf.graphics.beginFill(0x000000);
			this.colorSwf.graphics.drawRect(0, 10, 145, 219);
			this.colorSwf.graphics.endFill();

			this.colorSwf.alpha=0;

		}

		public function updateBgImage(num:int):void {
			this.bgImg.updateBmp("ui/7day/day_0" + num + ".png");
		}

		public function setState(v:int):void {

			switch (v) {
				case 1:
					this.stateImg.updateBmp("ui/7day/font_ylq.png");
					break;
				case 0:
					this.stateImg.updateBmp("ui/7day/font_klq.png");
					break;
				default:
					this.stateImg.fillEmptyBmd();
			}

		}

		public function setMask(v:Boolean):void {

			if (v) {
				this.bgImg.transform.colorTransform=new ColorTransform(0.33, 0.33, 0.33);
				 
				this.mouseEnabled=false;
			} else {
				this.bgImg.transform.colorTransform=new ColorTransform();
				 
				this.mouseEnabled=true;
			}

		}


	}
}
