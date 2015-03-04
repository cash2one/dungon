package com.leyou.ui.equip.child {
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.quickBuy.QuickBuyWnd;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class EquipLvupBar1 extends AutoSprite {

		private var moneyLbl:Label;
		private var itemLbl:Label;

		public function EquipLvupBar1() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipLvupBar1.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;
			this.itemLbl=this.getUIbyID("itemLbl") as Label;

			this.itemLbl.addEventListener(TextEvent.LINK, onLink);
			this.itemLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.itemLbl.mouseEnabled=true;
		}

		public function updateInfo(o:TEquipInfo):void {

			this.moneyLbl.text=o.lvup_money + "";
			this.itemLbl.htmlText="<font color='#cc54ea'><a href='event:xxx--"+ConfigEnum.equip25+"'><u><b>" + TableManager.getInstance().getItemInfo(ConfigEnum.equip25).name + "</b></u></a></font> x " + o.lvup_itemNum;
		}

		private function onLink(e:TextEvent):void {
			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(ConfigEnum.equip25, ConfigEnum.equip26);
			UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);

		}

		private function onMouseMove(e:MouseEvent):void {

			var i:int=this.itemLbl.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(this.itemLbl.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url.indexOf("--") > -1) {

				var tipsInfo:TipsInfo=new TipsInfo();
				tipsInfo.itemid=int(url.split("--")[1])
				tipsInfo.isShowPrice=false;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipsInfo, new Point(e.stageX, e.stageY));
			} else {

			}

		}

	}
}
