package com.leyou.ui.marry.childs {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMarry_lv;
	import com.ace.gameData.table.TMarry_ring;
	import com.ace.gameData.table.TRing_intensify;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;

	public class Marry4WndLable extends AutoSprite {

		private var currentfightLbl:Label;
		private var nameLbl0:Label;
		private var nameLbl3:Label;
		private var nameLbl7:Label;

		private var propNameLblArr:Array=[];
		private var propKeyLblArr:Array=[];

		private var propQhLblArr:Array=[];
		private var propAddblArr:Array=[];

		private var suitpropNameArr:Array=[];
		private var suitpropKeyArr:Array=[];

		public function Marry4WndLable() {
			super(LibManager.getInstance().getXML("config/ui/marry/marry4WndLable.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.currentfightLbl=this.getUIbyID("currentfightLbl") as Label;
			this.nameLbl0=this.getUIbyID("nameLbl0") as Label;
			this.nameLbl3=this.getUIbyID("nameLbl3") as Label;
			this.nameLbl7=this.getUIbyID("nameLbl7") as Label;

			for (var i:int=0; i < 3; i++) {
				this.propNameLblArr.push(this.getUIbyID("propName" + i + "Lbl") as Label);
				this.propKeyLblArr.push(this.getUIbyID("propKey" + i + "Lbl") as Label);

				this.propQhLblArr.push(this.getUIbyID("propQh" + i + "Lbl") as Label);
				this.propAddblArr.push(this.getUIbyID("propAdd" + i + "Lbl") as Label);

				this.suitpropNameArr.push(this.getUIbyID("suitpropName" + i) as Label);
				this.suitpropKeyArr.push(this.getUIbyID("suitpropKey" + i) as Label);
//				
//				this.propNameLblArr[i].mouseEnabled=true;
//				this.propQhLblArr[i].mouseEnabled=true;
//				this.suitpropNameArr[i].mouseEnabled=true;
				
			}

		}

		/**
		 *
		 * @param type
		 * @param lv
		 *
		 */
		public function updateInfo(mmd_l:int, type:int, lv:int):void {

			var infolv:TMarry_lv=TableManager.getInstance().getMarryLvBylv(mmd_l);
			var info:TMarry_ring=TableManager.getInstance().getMarryRingByid(type);

			var rinfo:TRing_intensify=TableManager.getInstance().getRing_intensifyByLv(lv);

			var rate:Number=rinfo.RI_Add / 10000;

			var num:int;
			var key:String;
			var tips:String;
			var frate:Number=0;

			var fight:Number=0;

			for (var i:int=0; i < 3; i++) {

				switch (i) {
					case 0:
						num=info.Att;
						key=PropUtils.getStringEasyById(4);
						frate=TableManager.getInstance().getZdlElement(4).rate;
						tips=TableManager.getInstance().getSystemNotice(9504).content;
						break;
					case 1:
						num=info.Def;
						key=PropUtils.getStringEasyById(5);
						frate=TableManager.getInstance().getZdlElement(5).rate;
						tips=TableManager.getInstance().getSystemNotice(9505).content;
						break;
					case 2:
						num=info.Hp;
						key=PropUtils.getStringEasyById(22);
						frate=TableManager.getInstance().getZdlElement(1).rate;
						tips=TableManager.getInstance().getSystemNotice(9501).content;
						break;
				}

				this.propNameLblArr[i].text="" + key + ":";
				this.propKeyLblArr[i].text="" + num;

				fight+=(num * frate);


				this.propQhLblArr[i].text="" + key + ":";
				this.propAddblArr[i].text="" + int((num * rate));

//				if (int((num * rate)) == 0) {
//					this.propQhLblArr[i].visible=false;
//					this.propAddblArr[i].visible=false;
//					this.nameLbl3.visible=false;
//				} else {
//					this.propQhLblArr[i].visible=true;
//					this.propAddblArr[i].visible=true;
//					this.nameLbl3.visible=true;
//				}

				fight+=((num + (num * rate)) * frate);

				this.suitpropNameArr[i].text="" + key + ":";
				this.suitpropKeyArr[i].text="" + int((num * infolv.ringAddRate / 10000));

//				if (int((num * infolv.ringAddRate / 10000)) == 0) {
//					this.suitpropNameArr[i].visible=false;
//					this.suitpropKeyArr[i].visible=false;
//					this.nameLbl7.visible=false;
//				} else {
//
//					this.suitpropNameArr[i].visible=true;
//					this.suitpropKeyArr[i].visible=true;
//					
//					if (this.nameLbl3.visible) {
//						this.nameLbl7.y=this.nameLbl3.y + this.nameLbl7.height + 3 * this.nameLbl7.height;
//					} else {
//						this.nameLbl7.y=this.nameLbl3.y;
//					}
//				}
//
//				this.suitpropNameArr[i].y=this.suitpropKeyArr[i].y=this.nameLbl7.y + this.nameLbl7.height + i * this.nameLbl7.height;

				this.propNameLblArr[i].setToolTip(tips);
				this.propQhLblArr[i].setToolTip(tips);
				this.suitpropNameArr[i].setToolTip(tips);
				
				fight+=((num + (num * infolv.ringAddRate / 10000)) * frate);
			}

			this.currentfightLbl.text="" + int(fight);


		}


	}
}
