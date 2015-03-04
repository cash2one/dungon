package com.leyou.ui.equip.child {


	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class EquipRecastBar1 extends AutoSprite {

		private var att1Lbl:Label;
		private var att2Lbl:Label;

		private var hp1Lbl:Label;
		private var hp2Lbl:Label;

		private var strengatt1Lbl:Label;
		private var strengatt2Lbl:Label;

		private var strenghp1Lbl:Label;
		private var strenghp2Lbl:Label;

		private var atttxtLbl:Label;
		private var hptxtLbl:Label;

		private var strengatttxtLbl:Label;
		private var strenghptxtLbl:Label;

		private var attImg:Image;
		private var att1Img:Image;

		private var hpImg:Image;
		private var hp1img:Image;

		private var strenghpImg:Image;
		private var strenghp1Img:Image;

		private var strengattImg:Image;
		private var strengatt1Img:Image;

		private var useGoldCb:RadioButton;
		private var useYuanbaoCb:RadioButton;

		private var goldLbl:Label;
		private var ybLbl:Label;

		private var goldImg:Image;
		private var ybImg:Image;

		public function EquipRecastBar1() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipRecastBar1.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.att1Lbl=this.getUIbyID("att1Lbl") as Label;
			this.att2Lbl=this.getUIbyID("att2Lbl") as Label;

			this.hp1Lbl=this.getUIbyID("hp1Lbl") as Label;
			this.hp2Lbl=this.getUIbyID("hp2Lbl") as Label;

			this.strengatt1Lbl=this.getUIbyID("strengatt1Lbl") as Label;
			this.strengatt2Lbl=this.getUIbyID("strengatt2Lbl") as Label;

			this.strenghp1Lbl=this.getUIbyID("strenghp1Lbl") as Label;
			this.strenghp2Lbl=this.getUIbyID("strenghp2Lbl") as Label;

			this.atttxtLbl=this.getUIbyID("atttxtLbl") as Label;
			this.hptxtLbl=this.getUIbyID("hptxtLbl") as Label;

			this.strengatttxtLbl=this.getUIbyID("strengatttxtLbl") as Label;
			this.strenghptxtLbl=this.getUIbyID("strenghptxtLbl") as Label;

			this.attImg=this.getUIbyID("attImg") as Image;
			this.att1Img=this.getUIbyID("att1Img") as Image;

			this.hpImg=this.getUIbyID("hpImg") as Image;
			this.hp1img=this.getUIbyID("hp1img") as Image;

			this.strenghpImg=this.getUIbyID("strenghpImg") as Image;
			this.strenghp1Img=this.getUIbyID("strenghp1Img") as Image;

			this.strengattImg=this.getUIbyID("strengattImg") as Image;
			this.strengatt1Img=this.getUIbyID("strengatt1Img") as Image;

			this.useGoldCb=this.getUIbyID("useGoldCb") as RadioButton;
			this.useYuanbaoCb=this.getUIbyID("useYuanbaoCb") as RadioButton;
			this.useGoldCb.turnOn();

			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.ybLbl=this.getUIbyID("ybLbl") as Label;

			this.goldImg=this.getUIbyID("goldImg") as Image;
			this.ybImg=this.getUIbyID("ybImg") as Image;

			this.attImg.visible=false;
			this.att1Img.visible=false;

			this.hpImg.visible=false;
			this.hp1img.visible=false;

			this.strenghpImg.visible=false;
			this.strenghp1Img.visible=false;

			this.strengattImg.visible=false;
			this.strengatt1Img.visible=false;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.goldImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.ybImg, einfo);
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (e == this.goldImg)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (e == this.ybImg)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		public function update(info:TipsInfo, succData:Object):void {

			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

//			this.useGoldCb.turnOn();

//			if (succData == null) {
				this.strenghptxtLbl.text="";
				this.strengatttxtLbl.text="";
				this.strenghp1Lbl.text="";
				this.strengatt1Lbl.text="";
				this.strengatt2Lbl.text="";
				this.hp2Lbl.text="";
				this.att2Lbl.text="";
				this.strenghp2Lbl.text="";

				this.attImg.visible=false;
				this.att1Img.visible=false;

				this.hpImg.visible=false;
				this.hp1img.visible=false;

				this.strenghpImg.visible=false;
				this.strenghp1Img.visible=false;

				this.strengattImg.visible=false;
				this.strengatt1Img.visible=false;

//			}

			this.goldLbl.text="" + einfo.rebudMoney;
			this.ybLbl.text="" + einfo.rebudIB;

			var pArr:Array=[];
			var key:String;
			var arr:Array;
			var i:int=0;

			for (key in info.p) {
				if (info.p[key] != 0 && int(key) <= 7 && key.indexOf("_") == -1) {
					pArr.push(key);

//					arr=PropUtils.getEquipColumnByIndex(int(key) - 1);
//					
//					this.viewrectTxtArr[i].text="" + PropUtils.propArr[int(key) - 1] + "随机区间:";
//					this.viewrectArr[i][0].text="" + einfo[arr[0]];
//					this.viewrectArr[i][1].text="" + einfo[arr[1]];
//					
//					this.viewTxtArr[i].text="原始" + PropUtils.propArr[int(key) - 1] + ":";
//					this.view1Arr[i].text="" + info.p[key];
//					
//					if (this.succData != null) {
//						this.view2Arr[i].text="" + this.succData.tp.p[key];
//					}

//					i++;
				}
			}

			if (pArr[0] == null)
				return;

			arr=PropUtils.getEquipColumnByIndex(int(pArr[0]) - 1);

			this.atttxtLbl.text="原始" + PropUtils.propArr[int(pArr[0]) - 1] + ":";
			this.att1Lbl.text="" + info.p[pArr[0]];

			if (succData != null) {
				this.att2Lbl.text="" + succData.tp.p[pArr[0]];

				this.att1Img.visible=true;
				this.attImg.visible=true;

				if (info.p[pArr[0]] > succData.tp.p[pArr[0]]) {
					this.attImg.updateBmp("ui/equip/equip_arrow3.png");
					this.att2Lbl.setTextFormat(FontEnum.getTextFormat("Red12"));
				} else if (info.p[pArr[0]] < succData.tp.p[pArr[0]]) {
					this.attImg.updateBmp("ui/equip/equip_arrow4.png");
					this.att2Lbl.setTextFormat(FontEnum.getTextFormat("Green12"));
				} else {
					this.attImg.visible=false;
					this.att2Lbl.setTextFormat(FontEnum.getTextFormat("White12"));
				}

			}

			if (info.p.hasOwnProperty("qh_" + pArr[0])) {

				this.strengatttxtLbl.text="强化" + PropUtils.propArr[int(pArr[0]) - 1] + ":";
				this.strengatt1Lbl.text="" + info.p["qh_" + pArr[0]];

				if (succData != null) {
					this.strengatt2Lbl.text="" + succData.tp.p["qh_" + pArr[0]];

					this.strengatt1Img.visible=true;
					this.strengattImg.visible=true;

					if (info.p["qh_" + pArr[0]] > succData.tp.p["qh_" + pArr[0]]) {
						this.strengattImg.updateBmp("ui/equip/equip_arrow3.png");
						this.strengatt2Lbl.setTextFormat(FontEnum.getTextFormat("Red12"));
					} else if (info.p["qh_" + pArr[0]] < succData.tp.p["qh_" + pArr[0]]) {
						this.strengattImg.updateBmp("ui/equip/equip_arrow4.png");
						this.strengatt2Lbl.setTextFormat(FontEnum.getTextFormat("Green12"));
					} else {
						this.strengattImg.visible=false;
						this.strengatt2Lbl.setTextFormat(FontEnum.getTextFormat("White12"));
					}

				}

			} else {

				this.strengatttxtLbl.text="强化" + PropUtils.propArr[int(pArr[0]) - 1] + ":";
				this.strengatt1Lbl.text="0";

				if (succData != null) {
					this.strengatt2Lbl.text="0";

					this.strengatt1Img.visible=true;
					this.strengatt2Lbl.setTextFormat(FontEnum.getTextFormat("White12"));
				}
			}

			if (pArr[1] == null) {
				this.hptxtLbl.text="";
				this.hp1Lbl.text="";
				this.hp2Lbl.text="";
				this.strenghptxtLbl.text="";
				this.strenghp1Lbl.text="";
				this.strenghp2Lbl.text="";

				return;
			}

			arr=PropUtils.getEquipColumnByIndex(int(pArr[1]) - 1);

			this.hptxtLbl.text="原始" + PropUtils.propArr[int(pArr[1]) - 1] + ":";
			this.hp1Lbl.text="" + info.p[pArr[1]];

			if (succData != null) {
				this.hp2Lbl.text="" + succData.tp.p[pArr[1]];

				this.hp1img.visible=true;
				this.hpImg.visible=true;

				if (info.p[pArr[1]] > succData.tp.p[pArr[1]]) {
					this.hpImg.updateBmp("ui/equip/equip_arrow3.png");
					this.hp2Lbl.setTextFormat(FontEnum.getTextFormat("Red12"));
				} else if (info.p[pArr[1]] < succData.tp.p[pArr[1]]) {
					this.hpImg.updateBmp("ui/equip/equip_arrow4.png");
					this.hp2Lbl.setTextFormat(FontEnum.getTextFormat("Green12"));
				} else {
					this.hpImg.visible=false;
					this.hp2Lbl.setTextFormat(FontEnum.getTextFormat("White12"));
				}
			}

			if (info.p.hasOwnProperty("qh_" + pArr[1])) {
				this.strenghptxtLbl.text="强化" + PropUtils.propArr[int(pArr[1]) - 1] + ":";
				this.strenghp1Lbl.text="" + info.p["qh_" + pArr[1]];

				if (succData != null) {
					this.strenghp2Lbl.text="" + succData.tp.p["qh_" + pArr[1]];

					this.strenghp1Img.visible=true;
					this.strenghpImg.visible=true;

					if (info.p["qh_" + pArr[1]] > succData.tp.p["qh_" + pArr[1]]) {
						this.strenghpImg.updateBmp("ui/equip/equip_arrow3.png");
						this.strenghp2Lbl.setTextFormat(FontEnum.getTextFormat("Red12"));
					} else if (info.p["qh_" + pArr[1]] < succData.tp.p["qh_" + pArr[1]]) {
						this.strenghpImg.updateBmp("ui/equip/equip_arrow4.png");
						this.strenghp2Lbl.setTextFormat(FontEnum.getTextFormat("Green12"));
					} else {
						this.strenghpImg.visible=false;
						this.strenghp2Lbl.setTextFormat(FontEnum.getTextFormat("White12"));
					}
				}
			} else {

				this.strenghptxtLbl.text="强化" + PropUtils.propArr[int(pArr[1]) - 1] + ":";
				this.strenghp1Lbl.text="0";

				if (succData != null) {
					this.strenghp2Lbl.text="0";
					
					this.strenghp1Img.visible=true;
					this.strenghp2Lbl.setTextFormat(FontEnum.getTextFormat("White12"));
				}
				
			}

		}

		public function getGold():int {
			return int(this.goldLbl.text);
		}

		public function getYb():int {
			return int(this.ybLbl.text);
		}

		public function getUseGold():Boolean {
			return this.useGoldCb.isOn;
		}

		public function getUseYb():Boolean {
			return this.useYuanbaoCb.isOn;
		}

		public function setUseGold(v:Boolean):void {
			if (v)
				this.useGoldCb.turnOn();
			else
				this.useGoldCb.turnOff();
		}

		public function setUseYb(v:Boolean):void {
			if (v)
				this.useYuanbaoCb.turnOn();
			else
				this.useYuanbaoCb.turnOff();
		}

	}
}
