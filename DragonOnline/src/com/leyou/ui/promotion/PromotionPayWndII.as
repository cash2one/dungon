package com.leyou.ui.promotion {
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.TabButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.data.paypromotion.PayPromotionDataII;
	import com.leyou.data.paypromotion.PayPromotionItem;
	import com.leyou.ui.promotion.children.PromotionExchangeRender;
	import com.leyou.ui.promotion.children.PromotionLotteryRender;
	import com.leyou.ui.promotion.children.PromotionSpendRender;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;

	public class PromotionPayWndII extends AutoWindow {

		private var timeLbl:Label;

		private var ordinationLbl:Label;

		private var payLbl:Label;

		private var payBtn:ImgButton;

		private var currentType:int=-1;

		private var tbuttons:Vector.<TabButton>;

		private var giftPanel:ScrollPane;

		// 消费 -- 1
		private var payGiftRenders:Vector.<PromotionSpendRender>;

		// 兑换 -- 2
		private var exchangeGiftRenders:Vector.<PromotionExchangeRender>;

		// 抽奖 -- 3
		private var lotteryRender:PromotionLotteryRender;

		public function PromotionPayWndII() {
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqWnd.xml"));
			init();
		}

		private function init():void {
			hideBg();
			payLbl=getUIbyID("payLbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
			ordinationLbl=getUIbyID("ordinationLbl") as Label;
			payBtn=getUIbyID("payBtn") as ImgButton;
			payLbl.multiline=true;

			giftPanel=new ScrollPane(655, 312);
			lotteryRender=new PromotionLotteryRender();
			giftPanel.x=174;
			giftPanel.y=229;
			lotteryRender.x=174;
			lotteryRender.y=229;
			pane.addChild(giftPanel);
			pane.addChild(lotteryRender);

			tbuttons=new Vector.<TabButton>();
			payGiftRenders=new Vector.<PromotionSpendRender>();
			exchangeGiftRenders=new Vector.<PromotionExchangeRender>();

//			clsBtn.y+=20;
			if (!Core.PAY_OPEN) {
				payBtn.setActive(false, 1, true);
			} else {
				payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "payBtn":
					PayUtil.openPayUrl();
					break;
				default:
					turnTo(int(event.target.name.substr(4)));
					break;
			}
		}

		private function getPayPromotionInfo(type:int):TPayPromotion {
			var pInfo:TPayPromotion;
			var proDic:Object=TableManager.getInstance().getPromotionDic();
			var serverTick:Number=DataManager.getInstance().payPromotionData_II.serverTick;
			for (var key:String in proDic) {
				var payPromotion:TPayPromotion=proDic[key];
				var sdate:Date=new Date();
				var edate:Date=new Date();
				sdate.time=Date.parse(DateUtil.convertDateStr(payPromotion.rp_time));
				edate.time=Date.parse(DateUtil.convertDateStr(payPromotion.end_time));
				if (serverTick > sdate.time && serverTick < edate.time) {
					if ((null == pInfo) && (payPromotion.type == type)) {
						pInfo=payPromotion;
					} else if ((null != pInfo) && (payPromotion.type == type) && (payPromotion.id < pInfo.id)) {
						pInfo=payPromotion;
					}
				}
			}
			return pInfo;
		}

		public function updateInfo():void {
			clearPanel(1, true);
			clearPanel(2, true);

			var count:int=0;
			var data:PayPromotionDataII=DataManager.getInstance().payPromotionData_II;
			var promotionData:Object=data.dataDic;
			for (var key:String in promotionData) {
				count++;
				var items:Vector.<PayPromotionItem>=promotionData[key];
				var length:int=items.length;
				for (var n:int=0; n < length; n++) {
					var info:PayPromotionItem=items[n];
					if (-1 == currentType) {
						currentType=info.type;
					}
					var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
					generateRender(info);
				}
				// 生成按钮
				var btnInfo:TPayPromotion=TableManager.getInstance().getPayPromotion(items[0].id);
				generateButton(btnInfo);
			}
			// 傻逼的抽奖模块加进来了 要额外检查
			var list1:Array=data.lotteryData1;
			if (null != list1) {
				count++;
				var lbtnInfo:TPayPromotion=getPayPromotionInfo(6);
				generateButton(lbtnInfo);
				lotteryRender.updateInfo();
			}
			refreshBtn(data);
			if (count <= 0) {
				hide();
				return;
			}
			var btn:TabButton=getButton(currentType);
			btn.turnOn(false);
			turnTo(currentType);
		}

		private function refreshBtn(data:PayPromotionDataII):void {
			var dataDic:Object=data.dataDic;
			for (var n:int=tbuttons.length - 1; n >= 0; n--) {
				var btn:TabButton=tbuttons[n];
				var type:int=int(btn.name.substr(4));
				if (((6 != type) && (null == dataDic[type])) || ((6 == type) && (null == data.lotteryData1))) {
					if (btn.hasEventListener(MouseEvent.CLICK)) {
						btn.removeEventListener(MouseEvent.CLICK, onMouseClick);
					}
					if (pane.contains(btn)) {
						pane.removeChild(btn);
					}
					tbuttons.splice(n, 1);
				}
			}
			var isContains:Boolean;
			var length:int=tbuttons.length;
			for (var m:int=0; m < length; m++) {
				var tabBtn:TabButton=tbuttons[m];
				tabBtn.x=34;
				tabBtn.y=229 + m * 43;
				if (currentType == int(tabBtn.name.substr(4))) {
					isContains=true;
				}
			}
			if (!isContains && (tbuttons.length > 0)) {
				currentType=int(tbuttons[0].name.substr(4));
			}
		}
 
		private function generateButton(btnInfo:TPayPromotion):void {
			var btn:TabButton=getButton(btnInfo.type);
			if (null == btn) {
//				var nbtn:TabButton = new TabButton("", "promotionTab", 0, null, "ui/wybq/"+btnInfo.btnUrl);
				var nbtn:TabButton=new TabButton(""+btnInfo.btn_des, "promotionTab", 0, null, "ui/common/" + btnInfo.btnUrl);
 
				nbtn.addEventListener(MouseEvent.CLICK, onMouseClick);
				nbtn.name="type" + btnInfo.type;
				pane.addChild(nbtn);
				tbuttons.push(nbtn);
			}
		}

		private function getButton(type:int):TabButton {
			var length:int=tbuttons.length;
			for (var n:int=0; n < length; n++) {
				var btn:TabButton=tbuttons[n];
				if (type == int(btn.name.substr(4))) {
					return btn;
				}
			}
			return null;
		}

		private function generateRender(info:PayPromotionItem):void {
			var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
			var id:int=tinfo.id;
			var showType:int=tinfo.showType;
			var length:int;
			var isContains:Boolean; 
			if (1 == showType) {
				isContains=false;
				var srender:PromotionSpendRender
				length=payGiftRenders.length;
				for (var i:int=0; i < length; i++) {
					srender=payGiftRenders[i];
					if ((null != srender) && (srender.id == id)) {
						srender.updateInfo(info);
						isContains=true;
					}
				}
				if (!isContains) {
					srender=new PromotionSpendRender();
					srender.updateInfo(info);
					payGiftRenders.push(srender);
				}
			} else if (2 == showType) {
				isContains=false;
				var exrender:PromotionExchangeRender;
				length=exchangeGiftRenders.length;
				for (var j:int=0; j < length; j++) {
					exrender=exchangeGiftRenders[j];
					if ((null != exrender) && (exrender.id == id)) {
						exrender.updateInfo(info);
						isContains=true;
					}
				}
				if (!isContains) {
					exrender=new PromotionExchangeRender();
					exrender.updateInfo(info);
					exchangeGiftRenders.push(exrender);
				}
			}
		}

		private function turnTo(type:int):void {
			currentType=type;
			var tinfo:TPayPromotion=getPayPromotionInfo(type);
			switch (type) {
				case 6:
					giftPanel.visible=false;
					lotteryRender.visible=true;
					break;
				default:
					giftPanel.visible=true;
					lotteryRender.visible=false;
					ViewRenderByType(type, tinfo.showType);
					break;
			}
			
			
			
			
			timeLbl.htmlText=tinfo.des2;
			ordinationLbl.htmlText=tinfo.des3;
			var dv:Object=DataManager.getInstance().payPromotionData_II.getMinV(type);
			var content:String=tinfo.des4;
			if (-1 == content.indexOf("{")) {
				payLbl.htmlText=content;
			} else {
				if (dv > 0) {
					payLbl.htmlText=StringUtil.substitute(content, dv);
				} else {
					payLbl.htmlText="";
				}
			}
		}

		private function ViewRenderByType(type:int, showType:int):void {
			var index:int;
			var length:int;
			if (1 == showType) {
				index=0;
				clearPanel(2);
				var srender:PromotionSpendRender
				length=payGiftRenders.length;
				for (var i:int=0; i < length; i++) {
					srender=payGiftRenders[i];
					if ((null != srender) && (srender.type == type)) {
						giftPanel.addToPane(srender);
						srender.y=index * 104;
						index++;
					} else if (null != srender) {
						if (giftPanel.contains(srender)) {
							giftPanel.delFromPane(srender);
						}
					}
				}
			} else if (2 == showType) {
				index=0;
				clearPanel(1);
				var exrender:PromotionExchangeRender;
				length=exchangeGiftRenders.length;
				for (var j:int=0; j < length; j++) {
					exrender=exchangeGiftRenders[j];
					if ((null != exrender) && (exrender.type == type)) {
						giftPanel.addToPane(exrender);
						exrender.y=index * 104;
						index++;
					} else if (null != exrender) {
						if (giftPanel.contains(exrender)) {
							giftPanel.delFromPane(exrender);
						}
					}
				}
			}
			giftPanel.scrollTo(0);
			giftPanel.updateUI();
		}

		private function clearPanel(showType:int, dispose:Boolean=false):void {
			var index:int;
			var length:int;
			if (1 == showType) {
				index=0;
				var srender:PromotionSpendRender
				length=payGiftRenders.length;
				for (var i:int=0; i < length; i++) {
					srender=payGiftRenders[i];
					if (null != srender) {
						if (giftPanel.contains(srender)) {
							giftPanel.delFromPane(srender);
						}
						if (dispose) {
							srender.die();
						}
					}
				}
				if (dispose) {
					payGiftRenders.length=0;
				}
			} else if (2 == showType) {
				index=0;
				var exrender:PromotionExchangeRender;
				length=exchangeGiftRenders.length;
				for (var j:int=0; j < length; j++) {
					exrender=exchangeGiftRenders[j];
					if (null != exrender) {
						if (giftPanel.contains(exrender)) {
							giftPanel.delFromPane(exrender);
						}
						if (dispose) {
							exrender.die();
						}
					}
				}
				if (dispose) {
					exchangeGiftRenders.length=0;
				}
			}
		}

		public function rollToPos(type:int, pos:int, num:int):void {
			lotteryRender.rollToPos(type, pos, num);
		}

		public function flyItem(type:int, id:int):void {
			for each (var render:PromotionSpendRender in payGiftRenders) {
				if (render.id == id) {
					render.flyItem();
					return;
				}
			}
			for each (var exrender:PromotionExchangeRender in exchangeGiftRenders) {
				if (exrender.id == id) {
					exrender.flyItem();
					return;
				}
			}
		}
	}
}
