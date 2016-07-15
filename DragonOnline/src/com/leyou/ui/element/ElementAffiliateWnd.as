package com.leyou.ui.element {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TElementInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.elementAdditional.ElementData;
	import com.leyou.data.elementAdditional.Elementry;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_ELEP;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	public class ElementAffiliateWnd extends AutoWindow {
		private var spriteLbl:Label;

		private var ruleLbl:Label;

		private var hintLbl:Label;

		private var clickLbl:Label;

		private var valueLbl:Label;

		private var progressImg:ScaleBitmap;

		private var remainLbl:Label;

		private var costLbl:Label;

		private var costDesLbl:Label;

		private var evolutionVLbl:Label;

		private var upgradeBtn:NormalButton;

		private var costDesLbl1:Label;

		private var costMoneyLbl:Label;

		private var evolutionValueLbl:Label;

		private var levelUpLbl:NormalButton;

		private var swfLoader:SwfLoader;

		private var eleLbl:Label;

		private var data:ElementData;

		private var isFirst:Boolean=true;

		private var progress:Number=0;

		private var popText:TextField;

		private var tipInfo:TipsInfo;

		private var itemId1:int;

		private var itemId2:int;
		private var _type:int;

		public function ElementAffiliateWnd() {
			super(LibManager.getInstance().getXML("config/ui/element/elementLvUpWnd.xml"));
			init();
		}

		private function init():void {
			hideBg();
			eleLbl=getUIbyID("eleLbl") as Label;
			spriteLbl=getUIbyID("spriteLbl") as Label;
//			ruleLbl=getUIbyID("ruleLbl") as Label;
			hintLbl=getUIbyID("hintLbl") as Label;
			clickLbl=getUIbyID("clickLbl") as Label;
			valueLbl=getUIbyID("valueLbl") as Label;
			progressImg=getUIbyID("progressImg") as ScaleBitmap;
			remainLbl=getUIbyID("remainLbl") as Label;
			costLbl=getUIbyID("costLbl") as Label;
			costDesLbl=getUIbyID("costDesLbl") as Label;
			evolutionVLbl=getUIbyID("evolutionVLbl") as Label;
			upgradeBtn=getUIbyID("upgradeBtn") as NormalButton;
			costDesLbl1=getUIbyID("costDesLbl1") as Label;
			costMoneyLbl=getUIbyID("costMoneyLbl") as Label;
			evolutionValueLbl=getUIbyID("evolutionValueLbl") as Label;
			levelUpLbl=getUIbyID("levelUpLbl") as NormalButton;

			clickLbl.mouseEnabled=true;
			clickLbl.addEventListener(MouseEvent.CLICK, onMouseClick);

			swfLoader=new SwfLoader();
			swfLoader.x=157;
			swfLoader.y=297 - 77;
			addChild(swfLoader);

			upgradeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			levelUpLbl.addEventListener(MouseEvent.CLICK, onMouseClick);

			popText=new TextField();
			popText.textColor=0xff00;
			popText.filters=[FilterEnum.hei_miaobian];
			addChild(popText);
			popText.visible=false;

			tipInfo=new TipsInfo();
			var style:StyleSheet=new StyleSheet();
			style.setStyle("a:hover", {color: "#ff0000"});
			costDesLbl.styleSheet=style;
			costDesLbl1.styleSheet=style;

			costDesLbl.mouseEnabled=true;
			costDesLbl1.mouseEnabled=true;
			costDesLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			costDesLbl1.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			costDesLbl1.addEventListener(MouseEvent.CLICK, onMouseClick);

			costDesLbl.textColor=0xff00;
			costDesLbl1.textColor=0xff00;
			
			clickLbl.styleSheet=style;
			clickLbl.htmlText=StringUtil_II.addEventString("clickLbl", clickLbl.text, true);
		}

		public override function get width():Number {
			return 306;
		}

		public override function get height():Number {
			return 544;
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "upgradeBtn":
					Cmd_ELEP.cm_ELEP_U(data.ctype, 1);
					break;
				case "clickLbl":
					UILayoutManager.getInstance().show_II(WindowEnum.SHIYI);
					TweenLite.delayedCall(0.3, UIManager.getInstance().shiyeWnd.setTabIndex, [4]);
					TweenLite.delayedCall(0.5, UIManager.getInstance().shiyeWnd.setSelectItem, [data.ctype]);
					break;
				case "levelUpLbl":
//					Cmd_ELEP.cm_ELEP_U(data.ctype, 2);

					var item2:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.element1.split("|")[0]);
					var num:int=MyInfoManager.getInstance().getBagItemNumByName(item2.name);
					var num2:int=costDesLbl1.text.split("x")[1];

					if (num < num2 && UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.element1.split("|")[0], ConfigEnum.element1.split("|")[1])) {
						Cmd_ELEP.cm_ELEP_U(data.ctype, 2, (UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.element1.split("|")[0], ConfigEnum.element1.split("|")[1]) == 0 ? 2 : 1));
					} else
						Cmd_ELEP.cm_ELEP_U(data.ctype, 2);

					GuideArrowDirectManager.getInstance().delArrow(WindowEnum.ELEMENT + "," + WindowEnum.ELEMENT_UPGRADE);
					break;
				case "costDesLbl1":
//					UILayoutManager.getInstance().show(WindowEnum.QUICK_BUY);
					UILayoutManager.getInstance().show(WindowEnum.ELEMENT, WindowEnum.QUICK_BUY);
					UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.element1.split("|")[0], ConfigEnum.element1.split("|")[1]);
//					var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
//					swnd.pushItem(ConfigEnum.MountItem, ConfigEnum.MountbindItem);
					break;
			}
		}

		protected function onMouseOver(event:MouseEvent):void {
			switch (event.target.name) {
				case "ruleLbl":
					var content:String=TableManager.getInstance().getSystemNotice(10104).content;
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
					break;
				case "costDesLbl":
					tipInfo.itemid=itemId1;
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
					break;
				case "costDesLbl1":
					tipInfo.itemid=itemId2;
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
					break;
			}
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			updateInfo();
		}

		public override function hide():void {
			super.hide();
			this.isFirst=true;

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.ELEMENT + "," + WindowEnum.ELEMENT_UPGRADE);
			UILayoutManager.getInstance().composingWnd(WindowEnum.ELEMENT);
		}

		public function updateInfo():void {
			data=DataManager.getInstance().elementData;
			var elementryData:Elementry=data.getEntryByType(data.ctype);
			var elementInfo:TElementInfo=TableManager.getInstance().getElementInfo(elementryData.type, elementryData.lv);
			spriteLbl.text=elementInfo.name;
			swfLoader.update(elementInfo.pnfId2);
			swfLoader.playAct("stand", 4);
			valueLbl.text=PropUtils.getStringById(100717) + ":" + elementryData.exp + "/" + elementInfo.exp;
			if (isFirst) {
				progressImg.scaleX=elementryData.exp / elementInfo.exp;
				isFirst=false;
			} else {
				progress=elementryData.exp / elementInfo.exp;
				if (progressImg.scaleX != progress) {
					if (progress > progressImg.scaleX) {
						TweenLite.to(progressImg, 1, {scaleX: progress});
					} else {
						TweenLite.to(progressImg, 0.5, {scaleX: 1, onComplete: onRollOver});
					}

					if (this._type == data.ctype)
						SoundManager.getInstance().play(elementInfo.sound1);
				}
			}

			this._type=data.ctype;
			remainLbl.text=data.stime + "";
			costLbl.text=elementInfo.energy + "";

			var itemId:int;
			if (1 == data.ctype) {
				itemId=ConfigEnum.element2.split("|")[0];
			} else if (2 == data.ctype) {
				itemId=ConfigEnum.element3.split("|")[0];
			} else if (3 == data.ctype) {
				itemId=ConfigEnum.element4.split("|")[0];
			} else if (4 == data.ctype) {
				itemId=ConfigEnum.element5.split("|")[0];
			} else if (5 == data.ctype) {
				itemId=ConfigEnum.element6.split("|")[0];
			}

			itemId1=itemId;
			itemId2=ConfigEnum.element1.split("|")[0];
			var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(itemId);
			eleLbl.text=itemInfo.name + PropUtils.getStringById(100400);

			costDesLbl.htmlText=StringUtil_II.addEventString("costDesLbl", itemInfo.name + "x" + elementInfo.itemNum2, true);

			var tbV:Array=ConfigEnum.element11.split("|");
			evolutionVLbl.text=PropUtils.getStringById(2295) + tbV[0] + "-" + tbV[1];

			itemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.element1.split("|")[0]);
			costDesLbl1.text=StringUtil_II.addEventString("costDesLbl1", itemInfo.name + "x" + elementInfo.itemNum1, true);
			costMoneyLbl.text=elementInfo.money + "";
			tbV=ConfigEnum.element10.split("|");
			evolutionValueLbl.text=PropUtils.getStringById(2295) + tbV[0] + "-" + tbV[1];
		}

		public function popUpText(value:int):void {
			popText.visible=true;
			popText.text=StringUtil.substitute(TableManager.getInstance().getSystemNotice(10117).content, value);
			popText.x=(306 - popText.width) * 0.5;
			popText.y=250;
			TweenLite.to(popText, 1, {y: popText.y - 30, onComplete: onMoveOver});

			function onMoveOver():void {
				popText.visible=false;
			}
		}

		private function onRollOver():void {
			progressImg.scaleX=0;
			TweenLite.to(progressImg, 0.5, {scaleX: progress});
		}
	}
}
