package com.leyou.ui.vip {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;

	public class VipListFlagRender extends AutoSprite {
		private var flagImg:Image;

		private var editLbl:Label;

		public function VipListFlagRender() {
			super(LibManager.getInstance().getXML("config/ui/vip/vipAllBtn.xml"));
			init();
		}

		private function init():void {
			flagImg=getUIbyID("flagImg") as Image;
			editLbl=getUIbyID("editLbl") as Label;
		}

		public function updateInfo(type:int, value:int):void {
			switch (type) {
				case 1:
					flagImg.visible=false;
					editLbl.visible=true;
					editLbl.text=value + "";
					break;
				case 2:
					flagImg.visible=false;
					editLbl.visible=true;
					editLbl.text=value + PropUtils.getStringById(1812);
					break;
				case 3:
					flagImg.visible=false;
					editLbl.visible=true;
					if (-1 == value) {
						editLbl.text=PropUtils.getStringById(1603);
					} else {
						editLbl.text="+" + value + PropUtils.getStringById(1977);
					}
					break;
				case 4:
					flagImg.visible=false;
					editLbl.visible=true;
					editLbl.text="+" + value + "%";
					break;
				case 5:
					flagImg.visible=true;
					var url:String=(0 != value) ? "ui/vip/btn_lqjlu_qued.png" : "ui/vip/btn_lqjlu_meiy.png";
					flagImg.updateBmp(url);
					editLbl.visible=false;
					break;
			}
		}
	}
}
