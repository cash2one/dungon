package com.leyou.ui.day7.child {


	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;

	public class SdayBtn extends AutoSprite {

		private var numImg:Image;
		private var sdayBtn:ImgButton;

		public function SdayBtn() {
			super(LibManager.getInstance().getXML("config/ui/7day/sdayBtn.xml"));
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
		}

		private function init():void {

			this.numImg=this.getUIbyID("numImg") as Image;
			this.sdayBtn=this.getUIbyID("sdayBtn") as ImgButton;

		}

		public function updateNumImage(num:int):void {
			this.numImg.updateBmp("ui/num/" + num + "_zdl.png");
		}

		public function setHight(v:Boolean):void {
			if (v)
				this.sdayBtn.turnOn();
			else
				this.sdayBtn.turnOff();

		}

	}
}
