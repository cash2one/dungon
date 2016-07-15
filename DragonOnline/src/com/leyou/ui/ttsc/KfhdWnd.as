package com.leyou.ui.ttsc {
	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.data.paypromotion.PayPromotionDataII;
	import com.leyou.data.paypromotion.PayPromotionItem;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.ui.promotion.children.PromotionExchangeRender;
	import com.leyou.ui.promotion.children.PromotionLotteryRender;
	import com.leyou.ui.promotion.children.PromotionSpendRender;
	import com.leyou.ui.tools.child.RightTopWidget;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.TimeUtil;
	
	import flash.events.MouseEvent;

	public class KfhdWnd extends AutoWindow {

		private var payLbl:Label;
		private var payBtn:ImgButton;
		private var listBtnArr:Array=[];

		private var titleIcon:Image;
		private var timeLbl:Label;
		private var ruleLbl:Label;

		private var dayLbl:Label;
		private var hourLbl:Label;
		private var monLbl:Label;
		private var secLbl:Label;

		private var minfo:Object;


		private var currentType:int=-1;

		private var tbuttons:Vector.<ImgLabelButton>;

		private var giftPanel:ScrollPane;

		// 消费 -- 1
		private var payGiftRenders:Vector.<PromotionSpendRender>;

		// 兑换 -- 2
		private var exchangeGiftRenders:Vector.<PromotionExchangeRender>;

		// 抽奖 -- 3
		private var lotteryRender:PromotionLotteryRender;

		public function KfhdWnd() {
			super(LibManager.getInstance().getXML("config/ui/ttsc/kfhdWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
			this.clsBtn.y=30;
		}

		private function init():void {

			this.payBtn=this.getUIbyID("payBtn") as ImgButton;
			this.payLbl=this.getUIbyID("payLbl") as Label;

			this.titleIcon=this.getUIbyID("titleIcon") as Image;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.dayLbl=this.getUIbyID("dayLbl") as Label;
			this.hourLbl=this.getUIbyID("hourLbl") as Label;
			this.monLbl=this.getUIbyID("monLbl") as Label;
			this.secLbl=this.getUIbyID("secLbl") as Label;

//			this.payBtn.addEventListener(MouseEvent.CLICK, onPay);
//			this.updateInit();

			giftPanel=new ScrollPane(655, 312);
			lotteryRender=new PromotionLotteryRender();
			giftPanel.x=174;
			giftPanel.y=229;
			lotteryRender.x=174;
			lotteryRender.y=229;
			this.addChild(giftPanel);
			this.addChild(lotteryRender);

			tbuttons=new Vector.<ImgLabelButton>();
			payGiftRenders=new Vector.<PromotionSpendRender>();
			exchangeGiftRenders=new Vector.<PromotionExchangeRender>();

//			clsBtn.y+=20;
			if (!Core.PAY_OPEN) {
				payBtn.setActive(false, 1, true);
			} else {
				payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}


		private function setState(v:Boolean):void {

			for (var i:int=0; i < this.tbuttons.length; i++) {
				if (v)
					this.tbuttons[i].turnOn();
				else
					this.tbuttons[i].turnOff();
			}

		}

//		private function onClick(e:MouseEvent):void {
//
//			this.setState(false);
//			e.target.turnOn();
//
//			var str:String=e.target.name;
//			var type:int=int(str.split("_")[1]);
//
//			var payarr:Array=TableManager.getInstance().getPayPromotionByType(type);
//			payarr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);
//
//			var pay:TPayPromotion=payarr[0];
//
//			this.ruleLbl.htmlText="" + pay.des3;
//
//			var d:Date=new Date();
//			d.time=this.minfo.opentime * 1000;
//
//			var startime:String=TimeUtil.getDateToString2(d);
//
//			d.date+=pay.day_end;
//			var endtime:String=TimeUtil.getDateToString2(d);
//
//			this.timeLbl.htmlText="" + StringUtil.substitute(pay.des2, [startime, endtime]);
//
//			var stime:int=this.minfo.stime;
//
//			d.time=d.time - this.minfo.stime * 1000;
//
//			if (d.time > 0) {
//				this.dayLbl.text="" + int(d.time / 1000 / 60 / 60 / 24);
//				this.hourLbl.text="" + int(d.time / 1000 / 60 / 60 % 24);
//				this.monLbl.text="" + int(d.time / 1000 / 60 % 60);
//				this.secLbl.text="" + int(d.time / 1000 % 60);
//			} else {
//				this.dayLbl.text="0";
//				this.hourLbl.text="0";
//				this.monLbl.text="0";
//				this.secLbl.text="0";
//			}
//
//		}

		protected function onMouseClick(event:MouseEvent):void {

			this.setState(false);
			event.target.turnOn();

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

//			for (var key:String in proDic) {
//				var payPromotion:TPayPromotion=proDic[key];
//				var sdate:Date=new Date();
//				var edate:Date=new Date();
//				sdate.time=Date.parse(DateUtil.convertDateStr(payPromotion.rp_time));
//				edate.time=Date.parse(DateUtil.convertDateStr(payPromotion.end_time));
//				if (serverTick > sdate.time && serverTick < edate.time) {
//					if ((null == pInfo) && (payPromotion.type == type)) {
//						pInfo=payPromotion;
//					} else if ((null != pInfo) && (payPromotion.type == type) && (payPromotion.id < pInfo.id)) {
//						pInfo=payPromotion;
//					}
//				}
//			}

			var parr:Array=TableManager.getInstance().getPayPromotionByType(type, this.minfo.st);
			parr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);
			pInfo=parr[0];
			return pInfo;
		}

		public function updateInfo(o:Object):void {

			if (o != null)
				this.minfo=o;

			clearPanel(1, true);
			clearPanel(2, true);

			var i:int=0;
			var count:int=0;
			var data:PayPromotionDataII=DataManager.getInstance().payPromotionData_III;
			var promotionData:Object=data.dataDic;

			var items:Vector.<PayPromotionItem>
			var id:int=int.MAX_VALUE;
			var iArr:Array=[];
			var dArr:Array=[];
			for (var key:String in promotionData) {
				iArr.push(int(key));
				dArr.push(promotionData[key]);
			}

			var imgbtn:ImgButton=UIManager.getInstance().rightTopWnd.getUIbyID("kfhdBtn") as ImgButton;
			if (this.minfo.st == 1) {
				imgbtn.updataBmd("ui/mainUI/main_button_kfhd.png");
			} else if (this.minfo.st == 2) {
				imgbtn.updataBmd("ui/mainUI/main_button_hfhd.png");
			}

			if (dArr.length == 0) {
				UIManager.getInstance().rightTopWnd.deactive("kfhdBtn");
				UIManager.getInstance().rightTopWnd.setEffect("kfhdBtn", false);
				return;
			} else {
				UIManager.getInstance().rightTopWnd.active("kfhdBtn");
				UIManager.getInstance().rightTopWnd.setEffect("kfhdBtn", true);
			}

			var j:int=0;

			for (i=0; i < dArr.length; i++) {
				for (j=i; j < dArr.length; j++) {
					if (int(dArr[i][0].id) > int(dArr[j][0].id)) {
						items=dArr[i];
						dArr[i]=dArr[j];
						dArr[j]=items;
					}
				}
			}


			var js:int=0;

			for (i=0; i < dArr.length; i++) {

				count++;
				items=dArr[i];
				var length:int=items.length;

				js=0;
				for (var n:int=0; n < length; n++) {
					var info:PayPromotionItem=items[n];
					if (-1 == currentType) {
						currentType=info.type;
					}
					var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
					generateRender(info);

					if (info.status == 1 && tinfo.showType == 1)
						js++;
				}
				// 生成按钮
				var btnInfo:TPayPromotion=TableManager.getInstance().getPayPromotion(items[0].id);
				generateButton(btnInfo, js);
			}

			/**
			 *  傻逼的抽奖模块加进来了 要额外检查
			 * */
			var list1:Array=data.lotteryData1;
			if (null != list1) {
				count++;
				var lbtnInfo:TPayPromotion=getPayPromotionInfo(6);
				generateButton(lbtnInfo);
				lotteryRender.updateInfoII();
			}
			refreshBtn(data);
			if (count <= 0) {
				hide();
				return;
			}

			var btn:ImgLabelButton=getButton(currentType);
			btn.turnOn(false);
			turnTo(currentType);


			if (this.minfo.st == 1) {
				this.titleIcon.updateBmp("ui/wybq/font_kfhd.png");
			} else if (this.minfo.st == 2) {
				this.titleIcon.updateBmp("ui/wybq/font_hfhd.png");
			}

		}

		private function refreshBtn(data:PayPromotionDataII):void {
			var dataDic:Object=data.dataDic;
			for (var n:int=tbuttons.length - 1; n >= 0; n--) {
				var btn:ImgLabelButton=tbuttons[n];
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
				var tabBtn:ImgLabelButton=tbuttons[m];
				tabBtn.x=34;
				tabBtn.y=72 + m * 50;
				if (currentType == int(tabBtn.name.substr(4))) {
					isContains=true;
				}
			}
			if (!isContains && (tbuttons.length > 0)) {
				currentType=int(tbuttons[0].name.substr(4));
			}
		}

		private function generateButton(btnInfo:TPayPromotion, js:int=0):void {
			var btn:ImgLabelButton=getButton(btnInfo.type);
			if (null == btn) {
//				var nbtn:TabButton = new TabButton("", "promotionTab", 0, null, "ui/wybq/"+btnInfo.btnUrl);
//				var nbtn:TabButton=new TabButton("" + btnInfo.btn_des, "promotionTab", 0, null, "ui/common/" + btnInfo.btnUrl);
//				var nbtn:TabButton=new TabButton("" + btnInfo.btn_des, "promotionTab", 0, null, "ui/common/" + btnInfo.btnUrl);
				btn=new ImgLabelButton("ui/common/" + btnInfo.btnUrl, btnInfo.btn_des, 0, 0, FontEnum.getTextFormat("message2"));

				btn.addEventListener(MouseEvent.CLICK, onMouseClick);
				btn.name="type" + btnInfo.type;
				pane.addChild(btn);
				tbuttons.push(btn);
			}

			var btnWidget:RightTopWidget;

			if (js > 0) {
				btnWidget=btn.getChildByName("btnWidget") as RightTopWidget;
				if (btnWidget == null) {
					btnWidget=new RightTopWidget();
					btnWidget.setpushContent();
					btn.addChild(btnWidget);
					btnWidget.x=btn.width - 55;
//					btnWidget.y=0;

					btnWidget.name="btnWidget";
				}

				btnWidget.setNum(js);
			} else {

				btnWidget=btn.getChildByName("btnWidget") as RightTopWidget;
				if (btnWidget != null)
					btn.removeChild(btnWidget);
			}
		}

		private function getButton(type:int):ImgLabelButton {
			var length:int=tbuttons.length;
			for (var n:int=0; n < length; n++) {
				var btn:ImgLabelButton=tbuttons[n];
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


			var payarr:Array=TableManager.getInstance().getPayPromotionByType(type, this.minfo.st);
			payarr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var pay:TPayPromotion=payarr[0];

			this.ruleLbl.htmlText="" + pay.des3;

			var d:Date=new Date();
			d.time=this.minfo.opentime * 1000;

			var startime:String=TimeUtil.getDateToString2(d);

			d.date+=pay.day_end;
			var endtime:String=TimeUtil.getDateToString2(d);

			this.timeLbl.htmlText="" + StringUtil.substitute(pay.des2, [startime, endtime]);

			var stime:int=this.minfo.stime;

			d.time=d.time - this.minfo.stime * 1000;

			if (d.time > 0) {
				this.dayLbl.text="" + int(d.time / 1000 / 60 / 60 / 24);
				this.hourLbl.text="" + int(d.time / 1000 / 60 / 60 % 24);
				this.monLbl.text="" + int(d.time / 1000 / 60 % 60);
				this.secLbl.text="" + int(d.time / 1000 % 60);
			} else {
				this.dayLbl.text="0";
				this.hourLbl.text="0";
				this.monLbl.text="0";
				this.secLbl.text="0";
			}

//			timeLbl.htmlText=tinfo.des2;
			ruleLbl.htmlText=tinfo.des3;

			var dv:Object=DataManager.getInstance().payPromotionData_III.getMinV(type);
			var content:String=tinfo.des4;
			if (-1 == content.indexOf("{")) {
				payLbl.htmlText=content;
			} else {
				if (dv != -1) {
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

//			DelayCallManager.getInstance().add(this, this.giftPanel.scrollTo, "updateUI", 2, 0);
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

			giftPanel.scrollTo(0);
			giftPanel.updateUI();

//			DelayCallManager.getInstance().add(this, this.giftPanel.scrollTo, "updateUI", 4, 0);
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

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			Cmd_Fanl.cm_Fanl_K();
		}

	}
}
