package com.leyou.ui.equip.child {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class EquipTransBar extends AutoSprite {

		private var lvtxtLbl:Label;
		private var lv1Lbl:Label;
		private var lv2Lbl:Label;

		private var atttxtLbl:Label;
		private var att1Lbl:Label;
		private var att2Lbl:Label;

		private var hptxtLbl:Label;
		private var hp1Lbl:Label;
		private var hp2Lbl:Label;

		private var goldLbl:Label;

		private var viewTxtArr:Array=[];
		private var view1Arr:Array=[];
		private var view2Arr:Array=[];
		private var view3Arr:Array=[];

		private var info:TipsInfo;
		private var info2:TipsInfo;
		/**
		 * 默认 -1
		 */
		private var rate:int=-1;

		private var goldImg:Image;

		private var dc:int=0;

		public function EquipTransBar() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipTransBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.lvtxtLbl=this.getUIbyID("lvtxtLbl") as Label;
			this.lv1Lbl=this.getUIbyID("lv1Lbl") as Label;
			this.lv2Lbl=this.getUIbyID("lv2Lbl") as Label;

			this.atttxtLbl=this.getUIbyID("atttxtLbl") as Label;
			this.att1Lbl=this.getUIbyID("att1Lbl") as Label;
			this.att2Lbl=this.getUIbyID("att2Lbl") as Label;

			this.hptxtLbl=this.getUIbyID("hptxtLbl") as Label;
			this.hp1Lbl=this.getUIbyID("hp1Lbl") as Label;
			this.hp2Lbl=this.getUIbyID("hp2Lbl") as Label;

			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.goldImg=this.getUIbyID("goldImg") as Image;

			this.viewTxtArr.push(this.atttxtLbl);
			this.viewTxtArr.push(this.hptxtLbl);

			this.view1Arr.push(this.att1Lbl);
			this.view1Arr.push(this.hp1Lbl);

			this.view2Arr.push(this.att2Lbl);
			this.view2Arr.push(this.hp2Lbl);

			this.view3Arr.push(this.getUIbyID("arrow2Img") as Image);
			this.view3Arr.push(this.getUIbyID("arrow3Img") as Image);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.goldImg, einfo);
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}


		public function updateData(info:Object, index:int):void {

			if (info == null) {
				if (index == 2) {
					this.rate=-1;
					this.info2=null;
				} else {
					this.info=null
				}
				return;
			}

			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

			if (index == 2) {
				var xml:XML=LibManager.getInstance().getXML("config/table/strengthen.xml");

				var tmpXml:XML;
				tmpXml=xml.strengthen[int(info.qh)];

				rate=tmpXml.@addRate;
				this.info2=info as TipsInfo;
				
				var egold:String=ConfigEnum["equip" + info.qh];
				
				if (egold.split("|")[0] == 1)
					this.goldImg.updateBmp("ui/backpack/moneyIco.png");
				else if (egold.split("|")[0] == 2)
					this.goldImg.updateBmp("ui/backpack/yuanbaoIco.png");
				
				this.goldLbl.text="" + egold.split("|")[1];
				
			} else {
				this.dc=int(einfo.dc);
//				this.goldLbl.text="" + einfo.dc;
				this.info=info as TipsInfo;
			}


			if (this.rate != -1 && this.info != null) {
				this.updataGridData();

				if (this.info2 != null) {
//					this.goldLbl.text="" + int(this.dc * int(ConfigEnum["equip" + this.info2.qh]));
				}
			}

		}

		public function getGold():int {
			return int(this.goldLbl.text);
		}

		private function updataGridData():void {

			var pArr:Array=[];
			var key:String;

			var i:int=0;
			for (key in info.p) {
				if (info.p[key] != 0 && key.indexOf("_") == -1 && int(key) <= 7) {

					this.lvtxtLbl.text=PropUtils.getStringById(1697);
					this.lv1Lbl.text="" + info.qh;

					this.viewTxtArr[i].text="" + PropUtils.propArr[int(key) - 1] + ":";
					this.view1Arr[i].text="" + info.p[key];

					this.lv2Lbl.text="" + info2.qh;
					this.view2Arr[i].text="" + (int(info.p[key]) + Math.ceil(rate / 100 * int(info.p[key])))

//					if (info.p.hasOwnProperty("qh_" + key)) {
//						this.view2Arr[i].text="(强化+" + info.p["qh_" + key] + ")";
//					}

					this.view3Arr[i].visible=true;
					i++;
				}
			}


			while (i <= 1) {
				this.view3Arr[i].visible=false;
				i++;
			}

		}

		public function clearData():void {
			this.hptxtLbl.text="";
			this.atttxtLbl.text="";

			this.info=null;
			this.info2=null;
			this.rate=-1;
			this.lv2Lbl.text="";
			this.lv1Lbl.text="";

			this.goldLbl.text="";

			for (var i:int=0; i < 2; i++) {
				this.viewTxtArr[i].text="";
				this.view1Arr[i].text="";
				this.view2Arr[i].text="";
			}

		}

	}
}
