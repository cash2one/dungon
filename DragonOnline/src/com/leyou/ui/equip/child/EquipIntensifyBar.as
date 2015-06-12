package com.leyou.ui.equip.child {

	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.utils.BadgeUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class EquipIntensifyBar extends AutoSprite {

		private var lvtxtLbl:Label;
		private var lv1Lbl:Label;
		private var lv2Lbl:Label;

		private var atttxtLbl:Label;
		private var att1Lbl:Label;
		private var att2Lbl:Label;

		private var hptxtLbl:Label;
		private var hp1Lbl:Label;
		private var hp2Lbl:Label;

		private var succLbl:Label;
		private var needGoldLbl:Label;
		private var goldImg:Image;

		private var needItemLbl:Label;
		private var moreRodioBtn:CheckBox;

		private var viewTxtArr:Array=[];
		private var view1Arr:Array=[];
		private var view2Arr:Array=[];
		private var view3Arr:Array=[];

		private var items:Array=[];

		public function EquipIntensifyBar() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipIntensifyBar.xml"));
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

			this.succLbl=this.getUIbyID("succLbl") as Label;
			this.needGoldLbl=this.getUIbyID("needGoldLbl") as Label;

			this.needItemLbl=this.getUIbyID("needItemLbl") as Label;
			this.moreRodioBtn=this.getUIbyID("moreRodioBtn") as CheckBox;

			this.goldImg=this.getUIbyID("goldImg") as Image;

			this.moreRodioBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.needItemLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.needItemLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			this.needItemLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.needItemLbl.addEventListener(TextEvent.LINK, onLink);
			this.needItemLbl.mouseEnabled=true;

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

		private function onLink(e:TextEvent):void {
			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(this.items[1], this.items[0]);
			UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
		}

		private function onMouseMove(e:MouseEvent):void {

			var i:int=this.needItemLbl.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(this.needItemLbl.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url.indexOf("--") > -1) {

				var tipsInfo:TipsInfo=new TipsInfo();
				tipsInfo.itemid=int(url.split("--")[1])

				tipsInfo.isShowPrice=false;

				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipsInfo, new Point(e.stageX, e.stageY));
			} else {

			}

		}

		private function onClick(e:MouseEvent):void {



		}

		public function updateData(info:TipsInfo):void {

			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			this.lv1Lbl.text="" + info.qh;
			this.lv2Lbl.text="" + (info.qh + 1);

			var xml:XML=LibManager.getInstance().getXML("config/table/strengthen.xml");

			var tmpXml:XML;
			if (info.qh >= int(einfo.maxlevel))
				tmpXml=xml.strengthen[int(this.lv1Lbl.text)];
			else
				tmpXml=xml.strengthen[int(this.lv2Lbl.text)];

			var rate:int=tmpXml.@addRate;

			var pArr:Array=[];
			var key:String;

			var i:int=0;
			for (key in info.p) {
				if (info.p[key] != 0 && key.indexOf("qh") == -1 && int(key) <= 7) {

					this.viewTxtArr[i].text="" + PropUtils.propArr[int(key) - 1];

					if (info.p.hasOwnProperty("qh_" + key))
						this.view1Arr[i].text="" + (int(info.p[key]) + int(info.p["qh_" + key]));
					else
						this.view1Arr[i].text="" + info.p[key];

					if (info.qh >= int(einfo.maxlevel)) {

						this.lv2Lbl.text="" + info.qh;
						this.view2Arr[i].text="" + (int(info.p[key]) + int(info.p["qh_" + key]));

					} else
						this.view2Arr[i].text="" + (int(info.p[key]) + Math.ceil(rate / 100 * int(info.p[key])));

					this.view3Arr[i].visible=true;
					i++;
				}
			}

			while (i <= 1) {
				this.view3Arr[i].visible=false;
				this.view2Arr[i].text="";
				this.view1Arr[i].text="";
				this.viewTxtArr[i].text="";
				i++;
			}

			var tmp1Xml:XML=xml.strengthen[int(this.lv1Lbl.text)];
//			this.succLbl.text="" + BadgeUtil.getTypeByRate(tmp1Xml.@sucessRate);
			this.succLbl.text="" + tmp1Xml.@sucessRate+"%";

			this.needGoldLbl.text="" + int(tmp1Xml.@money);

			var iteminfo:TItemInfo=TableManager.getInstance().getItemInfo(tmp1Xml.@item);
			this.needItemLbl.htmlText="<font color='#cc54ea'><a href='event:" + tmp1Xml.@item2 + "--" + iteminfo.id + "'><u><b>" + iteminfo.name + "</b></u></a></font> x " + tmp1Xml.@itemNum;

			this.items=[tmp1Xml.@item2, iteminfo.id];
		}

		public function buyItems():Boolean {

			var needNum:int=this.needItemLbl.text.split(" x ")[1];

			var num:int=MyInfoManager.getInstance().getBagItemNumByName(this.needItemLbl.text.split(" x ")[0]);
			if (num >= needNum)
				return false;


			if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(this.items[1], this.items[0])) {

				UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
				UIManager.getInstance().quickBuyWnd.pushItem(this.items[1], this.items[0], needNum);
				return true;

			} else {
//				
//				if (MyInfoManager.getInstance().getBagEmptyGridIndex(this.items[1], needNum) == -1 || MyInfoManager.getInstance().getBagEmptyGridIndex(this.items[0], needNum) == -1) {
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
//					return true;
//				}
//				
////				UIManager.getInstance().quickBuyWnd.enoughToBuy(
//				UIManager.getInstance().quickBuyWnd.getItemNotShow(this.items[1], this.items[0], needNum);
			}

			return false;
		}

		public function getitems():Array {
			return this.items;
		}

		public function needItems():Array {
			return this.needItemLbl.text.split(" x ");
		}

		public function get autoSuccess():Boolean {
			return this.moreRodioBtn.isOn;
		}

		public function get needGoldNum():int {
			return int(this.needGoldLbl.text);
		}

		public function get currentLv():int {
			return int(this.lv1Lbl.text);
		}

	}
}
