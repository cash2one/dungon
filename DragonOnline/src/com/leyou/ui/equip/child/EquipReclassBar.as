package com.leyou.ui.equip.child {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class EquipReclassBar extends AutoSprite {

		private var proLbl:Label;
		private var targetProLbl:Label;
		private var needGoldLbl:Label;
		private var needItemLbl:Label;
		private var need1GoldLbl:Label;
		private var need1ItemLbl:Label;

		private var cb1:RadioButton;
		private var cb2:RadioButton;

		private var tips:TipsInfo;

		public function EquipReclassBar() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipReclassBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.targetProLbl=this.getUIbyID("targetProLbl") as Label;

			this.needGoldLbl=this.getUIbyID("needGoldLbl") as Label;
			this.needItemLbl=this.getUIbyID("needItemLbl") as Label;

			this.need1GoldLbl=this.getUIbyID("need1GoldLbl") as Label;
			this.need1ItemLbl=this.getUIbyID("need1ItemLbl") as Label;

			this.cb1=this.getUIbyID("cb1") as RadioButton;
			this.cb2=this.getUIbyID("cb2") as RadioButton;

			this.targetProLbl.text="???";

			this.cb1.turnOn();

			this.cb1.addEventListener(MouseEvent.CLICK, onSelect);
			this.cb2.addEventListener(MouseEvent.CLICK, onSelect);

			this.cb1.setToolTip(TableManager.getInstance().getSystemNotice(2621).content);
			this.cb2.setToolTip(TableManager.getInstance().getSystemNotice(2622).content);

			this.needItemLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.need1ItemLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.needItemLbl.addEventListener(MouseEvent.CLICK, onSelect);
			this.need1ItemLbl.addEventListener(MouseEvent.CLICK, onSelect);

			this.needItemLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.needItemLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.need1ItemLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.need1ItemLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.needItemLbl.mouseEnabled=true;
			this.need1ItemLbl.mouseEnabled=true;
			
			this.tips=new TipsInfo();
		}

		private function onMouseOver(e:MouseEvent):void {
			this.tips.itemid=ConfigEnum.equip18;
			
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, this.tips, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onSelect(e:MouseEvent):void {
			var swnd:QuickBuyWnd;

			switch (e.target.name) {
				case "cb1":
					this.targetProLbl.text="???";
					break;
				case "cb2":
					this.targetProLbl.text="" + PlayerUtil.getPlayerRaceByIdx(Core.me.info.profession);
					break;
				case "needItemLbl":
					swnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
					swnd.pushItem(ConfigEnum.equip18, ConfigEnum.equip19);
					UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
					break;
				case "need1ItemLbl":
					swnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
					swnd.pushItem(ConfigEnum.equip18, ConfigEnum.equip19);
					UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
					break;
			}

		}

		public function setSelectCb1():void {
			this.cb1.turnOn();
		}

		public function updateInfo(o:Object):void {

			this.proLbl.text="";
			this.targetProLbl.text="";
			this.needGoldLbl.text="";
			this.needItemLbl.text="";

		}

		public function setPro(s:String=""):void {
			this.proLbl.text="" + s;
		}

		public function settargetPro(s:String="???"):void {
			this.targetProLbl.text="" + s;
		}

		public function setneedItem(info:TEquipInfo):void {

			var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.equip18);

			this.needItemLbl.textColor=ItemUtil.getColorByQuality(tinfo.quality);
			this.need1ItemLbl.textColor=ItemUtil.getColorByQuality(tinfo.quality);

			this.needGoldLbl.text=info.Ext_speed + "";
			this.needItemLbl.htmlText="<u><a href='event:--'>" + tinfo.name + "</a></u> x " + info.Ext_INum + "";

			this.need1GoldLbl.text=(info.Ext_speed * 2) + "";
			this.need1ItemLbl.htmlText="<u><a href='event:--'>" + tinfo.name + "</a></u> x " + (info.Ext_INum * 2) + "";

		}

		public function setViewBuy():Boolean {
			var arr:Array;
			if (this.cb1.isOn)
				arr=this.needItemLbl.text.split(" x ");
			else
				arr=this.need1ItemLbl.text.split(" x ");

			if (MyInfoManager.getInstance().getBagItemNumByName(arr[0]) >= int(arr[1])) {
				return false;
			}

			if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.equip18, ConfigEnum.equip19)) {

				if (ConfigEnum.MarketOpenLevel <= Core.me.info.level)
					UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);

				UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.equip18, ConfigEnum.equip19, int(arr[1]));

				return true;
			} else {

//				if (MyInfoManager.getInstance().getBagEmptyGridIndex(ConfigEnum.equip18, int(arr[1])) == -1 || MyInfoManager.getInstance().getBagEmptyGridIndex(ConfigEnum.equip19, int(arr[1])) == -1) {
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
//					return true;
//				}
//
//				UIManager.getInstance().quickBuyWnd.getItemNotShow(ConfigEnum.equip18, ConfigEnum.equip19, int(arr[1]));
			}

			return false;
		}

		public function getState():int {
			return (this.cb1.isOn ? 1 : 2);
		}


		public function getItemText():String {
			if (this.cb1.isOn)
				return this.needItemLbl.text;
			else
				return this.need1ItemLbl.text;
		}

	}
}
