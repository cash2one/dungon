package com.leyou.ui.equip.child {

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
	import flash.events.Event;
	import flash.geom.Point;

	public class EquipRecastBar2 extends AutoSprite {

		private var strengatttxtLbl:Label;
		private var strenghptxtLbl:Label;

		private var strengatt1Lbl:Label;
		private var strenghp1Lbl:Label;

		private var strengattrand1Lbl:Label;
		private var strengattrand2Lbl:Label;

		private var strenghprand1Lbl:Label;
		private var strenghprand2Lbl:Label;

		private var attrand1Lbl:Label;
		private var attrand2Lbl:Label;

		private var hprand1Lbl:Label;
		private var hprand2Lbl:Label;

		private var att1Lbl:Label;
		private var att2Lbl:Label;

		private var hp1Lbl:Label;
		private var hp2Lbl:Label;

		private var useGoldCb:RadioButton;
		private var useYuanbaoCb:RadioButton;

		private var atttxtLbl:Label;
		private var hptxtLbl:Label;

		private var fly1Lbl:Label;
		private var fly2Lbl:Label;

		private var fly3Lbl:Label;
		private var fly4Lbl:Label;

		private var goldLbl:Label;
		private var ybLbl:Label;

		private var goldImg:Image;
		private var ybImg:Image;

		public function EquipRecastBar2() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipRecastBar2.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.atttxtLbl=this.getUIbyID("atttxtLbl") as Label;
			this.hptxtLbl=this.getUIbyID("hptxtLbl") as Label;

			this.atttxtLbl=this.getUIbyID("atttxtLbl") as Label;
			this.hptxtLbl=this.getUIbyID("hptxtLbl") as Label;

			this.attrand1Lbl=this.getUIbyID("attrand1Lbl") as Label;
			this.attrand2Lbl=this.getUIbyID("attrand2Lbl") as Label;

			this.hprand1Lbl=this.getUIbyID("hprand1Lbl") as Label;
			this.hprand2Lbl=this.getUIbyID("hprand2Lbl") as Label;

			this.att1Lbl=this.getUIbyID("att1Lbl") as Label;
			this.att2Lbl=this.getUIbyID("att2Lbl") as Label;

			this.hp1Lbl=this.getUIbyID("hp1Lbl") as Label;
			this.hp2Lbl=this.getUIbyID("hp2Lbl") as Label;

			this.fly1Lbl=this.getUIbyID("fly1Lbl") as Label;
			this.fly2Lbl=this.getUIbyID("fly2Lbl") as Label;

			this.fly3Lbl=this.getUIbyID("fly3Lbl") as Label;
			this.fly4Lbl=this.getUIbyID("fly4Lbl") as Label;

			this.strengatttxtLbl=this.getUIbyID("strengatttxtLbl") as Label;
			this.strenghptxtLbl=this.getUIbyID("strenghptxtLbl") as Label;

			this.strengatt1Lbl=this.getUIbyID("strengatt1Lbl") as Label;
			this.strenghp1Lbl=this.getUIbyID("strenghp1Lbl") as Label;

			this.strengattrand1Lbl=this.getUIbyID("strengattrand1Lbl") as Label;
			this.strengattrand2Lbl=this.getUIbyID("strengattrand2Lbl") as Label;

			this.strenghprand1Lbl=this.getUIbyID("strenghprand1Lbl") as Label;
			this.strenghprand2Lbl=this.getUIbyID("strenghprand2Lbl") as Label;

			this.useGoldCb=this.getUIbyID("useGoldCb") as RadioButton;
			this.useYuanbaoCb=this.getUIbyID("useYuanbaoCb") as RadioButton;
			this.useGoldCb.turnOn();

			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.ybLbl=this.getUIbyID("ybLbl") as Label;

			this.goldImg=this.getUIbyID("goldImg") as Image;
			this.ybImg=this.getUIbyID("ybImg") as Image;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.goldImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.ybImg, einfo);
			
			this.addEventListener(Event.ADDED,onAdded);
			
		}
		
		private function onAdded(e:Event):void{
			this.useGoldCb.turnOn();
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

		public function update(info:TipsInfo):void {

			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

			var xml:XML=LibManager.getInstance().getXML("config/table/strengthen.xml");
			var tmpXml:XML=xml.strengthen[info.qh];

			var rate:int=tmpXml.@addRate;


			this.goldLbl.text="" + einfo.rebudMoney;
			this.ybLbl.text="" + einfo.rebudIB;

			var pArr:Array=[];
			var key:String;
			var arr:Array;
			var i:int=0;
			for (key in info.p) {
				if (info.p[key] != 0 && int(key) <= 7 && key.indexOf("_") == -1) { //<=7 只是基础属性;
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

			this.attrand1Lbl.text="" + einfo[arr[0]] + "~" + einfo[arr[1]];
//			this.attrand2Lbl.text="" + einfo[arr[1]];

			this.atttxtLbl.text=PropUtils.getStringById(1695) + PropUtils.propArr[int(pArr[0]) - 1] + ":";
			this.att1Lbl.text="" + info.p[pArr[0]];

			if (info.p.hasOwnProperty("qh_" + pArr[0])) {
				this.strengatttxtLbl.text=PropUtils.getStringById(1696) + PropUtils.propArr[int(pArr[0]) - 1] + ":";
				this.strengatt1Lbl.text="" + info.p["qh_" + pArr[0]];

				this.strengattrand1Lbl.text="" + Math.ceil(rate / 100 * int(einfo[arr[0]])) + "~" + Math.ceil(rate / 100 * int(einfo[arr[1]]));
//				this.strengattrand2Lbl.text="" +  Math.ceil(rate / 100 * int(einfo[arr[1]]));

//				this.fly3Lbl.text="~";
			} else {
				this.strengatttxtLbl.text="";
				this.strengatt1Lbl.text="";
				this.strengattrand1Lbl.text="";
				this.strengattrand2Lbl.text="";
				this.fly3Lbl.text="";
			}

			if (pArr[1] == null) {

				this.hprand1Lbl.text="";
				this.hprand2Lbl.text="";

				this.hptxtLbl.text="";
				this.hp1Lbl.text="";
				this.fly2Lbl.text="";

				this.strenghptxtLbl.text="";
				this.strenghp1Lbl.text="";

				this.strenghprand1Lbl.text="";
				this.strenghprand2Lbl.text="";

				this.fly4Lbl.text="";
				return;
			}

			arr=PropUtils.getEquipColumnByIndex(int(pArr[1]) - 1);

			this.hprand1Lbl.text="" + einfo[arr[0]] + "~" + einfo[arr[1]];
//			this.hprand2Lbl.text="" + einfo[arr[1]];

			this.hptxtLbl.text=PropUtils.getStringById(1695) + PropUtils.propArr[int(pArr[1]) - 1] + ":";
			this.hp1Lbl.text="" + info.p[pArr[1]];
//			this.fly2Lbl.text="~";

			if (info.p.hasOwnProperty("qh_" + pArr[1])) {

				this.strenghptxtLbl.text=PropUtils.getStringById(1696) + PropUtils.propArr[int(pArr[1]) - 1] + ":";
				this.strenghp1Lbl.text="" + info.p["qh_" + pArr[1]];

				this.strenghprand1Lbl.text="" + Math.ceil(rate / 100 * int(einfo[arr[0]]))+"~"+Math.ceil(rate / 100 * int(einfo[arr[1]]));
//				this.strenghprand2Lbl.text="" + Math.ceil(rate / 100 * int(einfo[arr[1]]));

//				this.fly4Lbl.text="~";
			} else {
				this.strenghptxtLbl.text="";
				this.strenghp1Lbl.text="";

				this.strenghprand1Lbl.text="";
//				this.strenghprand2Lbl.text="";

//				this.fly4Lbl.text="";
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

		private function clearAll():void {

		}

	}
}
