package com.leyou.ui.gem.child {


	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;

	public class GembtnWnd extends AutoSprite {

		private var nameLbl:Label;
		private var itemImg:Image;
		private var imgBtn:ImgButton;

		private var id:int=0;

		public function GembtnWnd() {
			super(LibManager.getInstance().getXML("config/ui/gem/gembtnWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.itemImg=this.getUIbyID("itemImg") as Image;
			this.imgBtn=this.getUIbyID("imgBtn") as ImgButton;

			this.x=5;
		}

		public function updateInfo(info:TEquipInfo):void {

			this.nameLbl.text="" + info.name + "(" + Math.floor(MyInfoManager.getInstance().getBagItemNumById(info.id - 1) / 3) + ")";
			this.nameLbl.textColor=ItemUtil.getColorByQuality(int(info.quality));

			this.itemImg.updateBmp("ico/items/" + info.icon + ".png");
			this.itemImg.setWH(20, 20);

			this.id=info.id;
		}

		public function getID():int {
			return this.id;
		}

		public function setSelectState(v:Boolean):void {
			if (v) {
				this.imgBtn.turnOn();
			} else {
				this.imgBtn.turnOff();
			}
		}

		override public function get height():Number {
			return 34;
		}

	}
}
