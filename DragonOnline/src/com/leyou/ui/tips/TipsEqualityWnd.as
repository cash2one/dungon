package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffAward;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;

	public class TipsEqualityWnd extends AutoSprite implements ITip {

		private var bgSc:ScaleBitmap;
		private var iconImg:Image;
		private var nameLbl:Label;
		private var activeLbl:Label;
		private var activeDescLbl:Label;
		private var nextLbl:Label;
		private var standlineImg:Image;

		private var propNameLblArr:Array=[];
		private var propKeyLblArr:Array=[];

		private var npropNameLblArr:Array=[];
		private var npropKeyLblArr:Array=[];

		private var itemColumn:Array=["attack", "phyDef", "life", "crit", "hit", "slay"];
		private var itemColumnIndex:Array=[4, 5, 22, 8, 10, 12];

		public function TipsEqualityWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsEqualityWnd.xml"));
			this.init();
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.activeLbl=this.getUIbyID("activeLbl") as Label;
			this.activeDescLbl=this.getUIbyID("activeDescLbl") as Label;

			this.nextLbl=this.getUIbyID("nextLbl") as Label;
			this.bgSc=this.getUIbyID("bgSc") as ScaleBitmap;

			this.standlineImg=this.getUIbyID("standlineImg") as Image;

			for (var i:int=0; i < 6; i++) {
				this.propNameLblArr.push(this.getUIbyID("propName" + i + "Lbl") as Label);
				this.propKeyLblArr.push(this.getUIbyID("propKey" + i + "Lbl") as Label);

				this.npropNameLblArr.push(this.getUIbyID("npropName" + i + "Lbl") as Label);
				this.npropKeyLblArr.push(this.getUIbyID("npropKey" + i + "Lbl") as Label);
			}


		}

		public function updateInfo(info:Object):void {

			var binfo:TBuffAward=TableManager.getInstance().getBuffAwardById(info.id);
			var dataArr:Array=[];

			switch (info.id) {
				case 4:
					this.iconImg.updateBmp("ui/character/img_equality_3.png");
					break;
				case 5:
					this.iconImg.updateBmp("ui/character/img_equality_4.png");
					break;
				case 6:
					this.iconImg.updateBmp("ui/character/img_equality_5.png");
					break;
			}

			this.nameLbl.text="" + binfo.name;

			var c:int=0;

			if (info.active) {
				this.activeLbl.text="";
				this.activeDescLbl.visible=false;
				this.iconImg.filters=[];

				this.setPropVisible(true);

				var i:int=0;
				for (i=0; i < 6; i++) {
					if (binfo[this.itemColumn[i]] == 0) {
						this.propNameLblArr[i].visible=false;
						this.propKeyLblArr[i].visible=false;

						continue;
					} else {
						this.propNameLblArr[i].visible=true;
						this.propKeyLblArr[i].visible=true;
					}

					this.propNameLblArr[c].text="" + PropUtils.getStringEasyById(this.itemColumnIndex[i]) + ":";
					this.propKeyLblArr[c].text="" + binfo[this.itemColumn[i]];

					c++;
				}

			} else {
				this.activeLbl.text="" + PropUtils.getStringById(2291);
				this.iconImg.filters=[FilterUtil.enablefilter];
				this.activeDescLbl.visible=true;
				this.setPropVisible(false);

				this.propNameLblArr[0].text="" + PropUtils.getStringById(1594);
				this.propNameLblArr[0].visible=true;

				c++;
			}


			this.standlineImg.y=this.propNameLblArr[c].y + 3;
			this.nextLbl.y=this.standlineImg.y + 10;

			if (info.id > 4) {

				this.nextLbl.text=PropUtils.getStringById(2294) + "";
				this.nextLbl.x=112;

				this.setNextPropVisible(false);

				this.bgSc.height=this.nextLbl.y + this.nextLbl.height + 10;

			} else {

				var strid:int=1607;
				var id:int=info.id;
				if (info.active) {
					id+=1;
					strid+=1;
				}

				this.nextLbl.text=PropUtils.getStringById(2290) + " " + (PropUtils.getStringById(strid)) + PropUtils.getStringById(2293) + "(" + info.next + "/14)";
				this.nextLbl.x=10;
				this.setNextPropVisible(true);

				var info2:TBuffAward=TableManager.getInstance().getBuffAwardById(id);

				c=0;
				for (i=0; i < 6; i++) {

					if (info2[this.itemColumn[i]] == 0) {
						this.npropNameLblArr[i].visible=false;
						this.npropKeyLblArr[i].visible=false;

						continue;
					} else {
						this.npropNameLblArr[i].visible=true;
						this.npropKeyLblArr[i].visible=true;
					}

					this.npropNameLblArr[c].text="" + PropUtils.getStringEasyById(this.itemColumnIndex[i]) + ":";
					this.npropKeyLblArr[c].text="" + info2[this.itemColumn[i]];

					this.npropNameLblArr[c].y=this.npropKeyLblArr[c].y=this.nextLbl.y + this.nextLbl.height + this.nextLbl.height * i;

					c++;
				}

				this.bgSc.height=this.npropNameLblArr[c - 1].y + this.npropNameLblArr[c - 1].height + 10;
			}



		}

		public function get isFirst():Boolean {
			//TODO: implement function
			return false;
		}


		private function setPropVisible(v:Boolean):void {
			for (var i:int=0; i < 6; i++) {
				this.propNameLblArr[i].visible=v;
				this.propKeyLblArr[i].visible=v;
			}
		}

		private function setNextPropVisible(v:Boolean):void {

			for (var i:int=0; i < 6; i++) {
				this.npropNameLblArr[i].visible=v;
				this.npropKeyLblArr[i].visible=v;
			}

		}


	}
}
