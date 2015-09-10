package com.leyou.ui.gem.child {


	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAlchemy;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;

	import flash.sampler.getInvocationCount;

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

		public function updateInfo(tinfo:TAlchemy):void {

			var num:int=int.MAX_VALUE;
			var d:int=0;
			var rate:int=0;
			for (var i:int=0; i < 5; i++) {
				if (tinfo["Datum" + (i + 1)] > 0) {
					d=MyInfoManager.getInstance().getBagItemNumById(tinfo["Datum" + (i + 1)]);
					if (d < tinfo["Datum_Num" + (i + 1)]) {
						num=0;
						rate=0;
						break;
					} else {
						if (d < num) {
							num=d;
							rate=tinfo["Datum_Num" + (i + 1)];
						}
					}
				}
			}

			this.nameLbl.text="" + tinfo.AlThird_Nam + "(" + int(Math.floor(num / rate)) + ")";
//			this.nameLbl.text="" + info.name + "(" + Math.floor(MyInfoManager.getInstance().getBagItemNumById(info.id - 1) / 3) + ")";
//			this.nameLbl.textColor=ItemUtil.getColorByQuality(int(info.quality));

			var info:Object;
			for (i=0; i < 3; i++) {
				if (tinfo["Product" + (i + 1)] > 0) {
					if (tinfo["Product" + (i + 1)] > 10000)
						info=TableManager.getInstance().getItemInfo(tinfo["Product" + (i + 1)]);
					else
						info=TableManager.getInstance().getEquipInfo(tinfo["Product" + (i + 1)]);

					this.itemImg.updateBmp("ico/items/" + info.icon + ".png");
					break;
				}
			}

			this.itemImg.setWH(15, 15);

			this.id=tinfo.Al_ID;
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
			return 25;
		}

	}
}
