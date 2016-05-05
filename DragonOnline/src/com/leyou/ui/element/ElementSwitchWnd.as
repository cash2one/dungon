package com.leyou.ui.element {
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TElementInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.elementAdditional.ElementData;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_ELEP;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;

	public class ElementSwitchWnd extends AutoWindow {
		private var subTitleLbl:Label;

		private var fightLbl:Label;

		private var nFightLbl:Label;

		private var signImg:Image;

		private var differenceLbl:Label;

		private var restrainEleLbl:Label;

		private var nRestrainEleLbl:Label;

		private var beRestrainEleLbl:Label;

		private var nBeRestrainEleLbl:Label;

		private var itemBtn:RadioButton;

		private var spareItemBtn:RadioButton;

		private var itemNameLbl:Label;

		private var spareItemNameLbl:Label;

		private var moneyLbl:Label;

		private var energyLbl:Label;

		private var confirmBtn:NormalButton;

		private var cancelBtn:NormalButton;

		private var costType:int;

		private var destType:int;

		private var tipInfo:TipsInfo;

		private var itemId:int;

		public function ElementSwitchWnd() {
			super(LibManager.getInstance().getXML("config/ui/element/elementChangeWnd.xml"));
			init();
		}

		private function init():void {
			subTitleLbl=getUIbyID("titleLbl") as Label;
			fightLbl=getUIbyID("fightLbl") as Label;
			nFightLbl=getUIbyID("nFightLbl") as Label;
			signImg=getUIbyID("signImg") as Image;
			differenceLbl=getUIbyID("differenceLbl") as Label;
			restrainEleLbl=getUIbyID("restrainEleLbl") as Label;
			nRestrainEleLbl=getUIbyID("nRestrainEleLbl") as Label;
			beRestrainEleLbl=getUIbyID("beRestrainEleLbl") as Label;
			nBeRestrainEleLbl=getUIbyID("nBeRestrainEleLbl") as Label;
			itemBtn=getUIbyID("itemBtn") as RadioButton;
			spareItemBtn=getUIbyID("spareItemBtn") as RadioButton;
			itemNameLbl=getUIbyID("itemNameLbl") as Label;
			spareItemNameLbl=getUIbyID("spareItemNameLbl") as Label;
			moneyLbl=getUIbyID("moneyLbl") as Label;
			energyLbl=getUIbyID("energyLbl") as Label;
			confirmBtn=getUIbyID("confirmBtn") as NormalButton;
			cancelBtn=getUIbyID("cancelBtn") as NormalButton;
			itemBtn.turnOn(false);
			costType=1;

			confirmBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			itemBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			spareItemBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			tipInfo=new TipsInfo();
			var style:StyleSheet=new StyleSheet();
			style.setStyle("a:hover", {color: "#ff0000"});
			itemNameLbl.styleSheet=style;
			spareItemNameLbl.styleSheet=style;

			itemNameLbl.textColor=0xff00;
			spareItemNameLbl.textColor=0xff00;

			itemNameLbl.mouseEnabled=true;
			spareItemNameLbl.mouseEnabled=true;
			itemNameLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			spareItemNameLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			spareItemNameLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		protected function onMouseOver(event:MouseEvent):void {
			switch (event.target.name) {
				case "itemNameLbl":
					tipInfo.itemid=itemId;
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
					break;
				case "spareItemNameLbl":
					tipInfo.itemid=ConfigEnum.element1.split("|")[0];
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
					break;
			}
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "confirmBtn":
					if (costType == 2) {
						var item2:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.element1.split("|")[0]);
						var num:int=MyInfoManager.getInstance().getBagItemNumByName(item2.name);

						if (num < ConfigEnum.element7 && UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.element1.split("|")[0], ConfigEnum.element1.split("|")[1])) {
							Cmd_ELEP.cm_ELEP_S(destType, costType, (UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.element1.split("|")[0], ConfigEnum.element1.split("|")[1])==0?2:1));
						} else
							Cmd_ELEP.cm_ELEP_S(destType, costType);

					} else
						Cmd_ELEP.cm_ELEP_S(destType, costType);
					hide();
					break;
				case "cancelBtn":
					hide();
					break;
				case "itemBtn":
					costType=1;
					break;
				case "spareItemBtn":
					costType=2;
					break;
				case "spareItemNameLbl":
					UILayoutManager.getInstance().show(WindowEnum.ELEMENT, WindowEnum.QUICK_BUY);
					UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.element1.split("|")[0], ConfigEnum.element1.split("|")[1]);
					break;
			}
		}

//		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
//			super.show(toTop, $layer, toCenter);
//		}

		public function updateInfo(stype:int):void {
			destType=stype;
			var data:ElementData=DataManager.getInstance().elementData;
			var cEleInfo:TElementInfo=TableManager.getInstance().getElementInfo(data.ctype, data.getEntryByType(data.ctype).lv);
			var nEleInfo:TElementInfo=TableManager.getInstance().getElementInfo(stype, data.getEntryByType(stype).lv);
			var content:String=TableManager.getInstance().getSystemNotice(10113).content;
			content=StringUtil.substitute(content, cEleInfo.name, nEleInfo.name);
			subTitleLbl.htmlText=content;
			restrainEleLbl.text=ElementUtil.getOppositeElementry(data.ctype);
			nRestrainEleLbl.text=ElementUtil.getOppositeElementry(stype);
			beRestrainEleLbl.text=ElementUtil.getBiOppositeElementry(data.ctype);
			nBeRestrainEleLbl.text=ElementUtil.getBiOppositeElementry(stype);

			if (1 == stype) {
				itemId=ConfigEnum.element2.split("|")[0];
			} else if (2 == stype) {
				itemId=ConfigEnum.element3.split("|")[0];
			} else if (3 == stype) {
				itemId=ConfigEnum.element4.split("|")[0];
			} else if (4 == stype) {
				itemId=ConfigEnum.element5.split("|")[0];
			} else if (5 == stype) {
				itemId=ConfigEnum.element6.split("|")[0];
			}
			var item1:TItemInfo=TableManager.getInstance().getItemInfo(itemId);

			itemNameLbl.htmlText=StringUtil_II.addEventString("itemNameLbl", item1.name + "x" + ConfigEnum.element8, true);
//			itemNameLbl.text = item1.name+"x"+ConfigEnum.element8;

			moneyLbl.text=ConfigEnum.element19 + "";
			var item2:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.element1.split("|")[0]);

			spareItemNameLbl.htmlText=StringUtil_II.addEventString("spareItemNameLbl", item2.name, true);
//			spareItemNameLbl.text = item2.name;

			energyLbl.text=ConfigEnum.element18 + "";
		}

		public function updateCombatPower(obj:Object):void {
			var zdl:int=obj.zdl;
			var czdl:int=obj.czdl;

			fightLbl.text=czdl + "";
			nFightLbl.text=(czdl + zdl) + "";
			differenceLbl.text=zdl + "";
			if (zdl > 0) {
				signImg.updateBmp("ui/equip/equip_arrow4.png");
			} else {
				signImg.updateBmp("ui/equip/equip_arrow3.png");
			}
		}
	}
}
