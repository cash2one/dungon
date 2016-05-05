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
	import com.leyou.data.paypromotion.PayPromotionData;
	import com.leyou.data.paypromotion.PayPromotionItem;
	import com.leyou.ui.promotion.children.PromotionCollectWordRender;
	import com.leyou.ui.promotion.children.PromotionCostGiftRender;
	import com.leyou.ui.promotion.children.PromotionExchangeRender;
	import com.leyou.ui.promotion.children.PromotionHourseRender;
	import com.leyou.ui.promotion.children.PromotionLotteryRender;
	import com.leyou.ui.promotion.children.PromotionPayRender;
	import com.leyou.ui.promotion.children.PromotionSpendRender;
	import com.leyou.ui.promotion.children.PromotionVipRender;
	import com.leyou.ui.promotion.children.PromotionWingRender;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;

	public class PromotionPayWnd extends AutoWindow {
		
		private var timeLbl:Label;

		private var ordinationLbl:Label;

		private var payBtn:ImgButton;

		private var payGiftBtn:TabButton;

		private var rideGiftBtn:TabButton;

		private var wingGiftBtn:TabButton;
		
		private var collectWordGift:TabButton;
		
		private var boxGiftBtn:TabButton;
		
		private var lotteryGiftBtn:TabButton;
		
		private var vipGiftBtn:TabButton;
		
		private var costBtn:TabButton;
		
		private var dayGiftBtn:TabButton;

		private var payGiftPanel:ScrollPane;

		private var rideGiftPanel:ScrollPane;

		private var wingGiftPanel:ScrollPane;
		
		private var collectWordPanel:ScrollPane;
		
		private var boxGiftPanel:ScrollPane;
		
		private var vipGiftPanel:ScrollPane;
		
		private var costGiftPanel:ScrollPane;
		
		private var dayGiftPanel:ScrollPane;
		
		private var lotteryRender:PromotionLotteryRender;

		private var payGiftRenders:Vector.<PromotionSpendRender>;

		private var rideGiftRenders:Vector.<PromotionHourseRender>;

		private var wingGiftRenders:Vector.<PromotionWingRender>;
		
		private var collectWordRenders:Vector.<PromotionExchangeRender>;
		
		private var boxGiftRenders:Vector.<PromotionCollectWordRender>;
		
		private var vipGiftRenders:Vector.<PromotionVipRender>;
		
		private var costGiftRenders:Vector.<PromotionCostGiftRender>;
		
		private var dayGiftRenders:Vector.<PromotionPayRender>;

		private var currentType:int = -1;

		private var payLbl:Label;
		
		private var tbuttons:Vector.<TabButton>;

		public function PromotionPayWnd() {
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqWnd.xml"));
//			init();
		}

//		public function init():void {
//			hideBg();
//			timeLbl=getUIbyID("timeLbl") as Label;
//			ordinationLbl=getUIbyID("ordinationLbl") as Label;
//			payBtn=getUIbyID("payBtn") as ImgButton;
//			
//			boxGiftBtn=getUIbyID("boxGift") as TabButton;
//			lotteryGiftBtn=getUIbyID("lotteryGift") as TabButton;
//			payGiftBtn=getUIbyID("payGift") as TabButton;
//			rideGiftBtn=getUIbyID("rideGift") as TabButton;
//			wingGiftBtn=getUIbyID("wingGift") as TabButton;
//			collectWordGift=getUIbyID("collectWordGift") as TabButton;
//			vipGiftBtn=getUIbyID("vipGift") as TabButton;
//			costBtn=getUIbyID("costBtn") as TabButton;
//			dayGiftBtn=getUIbyID("dayGiftBtn") as TabButton;
//			
//			payGiftPanel=new ScrollPane(655, 312);
//			rideGiftPanel=new ScrollPane(655, 312);
//			wingGiftPanel=new ScrollPane(655, 312);
//			collectWordPanel=new ScrollPane(655, 312);
//			boxGiftPanel=new ScrollPane(655, 312);
//			vipGiftPanel=new ScrollPane(655, 312);
//			costGiftPanel=new ScrollPane(655, 312);
//			lotteryRender=new PromotionLotteryRender();
//			dayGiftPanel=new ScrollPane(655, 312);
//			payGiftPanel.x = 174;
//			payGiftPanel.y = 229;
//			rideGiftPanel.x = 174;
//			rideGiftPanel.y = 229;
//			wingGiftPanel.x = 174;
//			wingGiftPanel.y = 229;
//			collectWordPanel.x = 174;
//			collectWordPanel.y = 229;
//			lotteryRender.x = 174;
//			lotteryRender.y = 229;
//			boxGiftPanel.x = 174;
//			boxGiftPanel.y = 229;
//			vipGiftPanel.x = 174;
//			vipGiftPanel.y = 229;
//			costGiftPanel.x = 174;
//			costGiftPanel.y = 229;
//			lotteryRender.x = 174;
//			lotteryRender.y = 229;
//			dayGiftPanel.x = 174;
//			dayGiftPanel.y = 229;
//			addChild(payGiftPanel);
//			addChild(rideGiftPanel);
//			addChild(wingGiftPanel);
//			addChild(collectWordPanel);
//			addChild(boxGiftPanel);
//			addChild(lotteryRender);
//			addChild(vipGiftPanel);
//			addChild(costGiftPanel);
//			addChild(dayGiftPanel);
//			payLbl=getUIbyID("payLbl") as Label;
//			payLbl.multiline=true;
////			payLbl.wordWrap=true;
//			payGiftRenders=new Vector.<PromotionSpendRender>();
//			rideGiftRenders=new Vector.<PromotionHourseRender>();
//			wingGiftRenders=new Vector.<PromotionWingRender>();
//			collectWordRenders=new Vector.<PromotionExchangeRender>();
//			boxGiftRenders=new Vector.<PromotionCollectWordRender>();
//			vipGiftRenders=new Vector.<PromotionVipRender>();
//			costGiftRenders=new Vector.<PromotionCostGiftRender>();
//			dayGiftRenders=new Vector.<PromotionPayRender>();
//			clsBtn.y+=20;
//			payGiftPanel.mouseChildren=true;
//			rideGiftPanel.mouseChildren=true;
//			wingGiftPanel.mouseChildren=true;
//			collectWordPanel.mouseChildren=true;
//			vipGiftPanel.mouseChildren=true;
//			if (!Core.PAY_OPEN) {
//				payBtn.setActive(false, 1, true);
//			} else {
//				payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			}
//			boxGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			lotteryGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			payGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			rideGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			wingGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			collectWordGift.addEventListener(MouseEvent.CLICK, onMouseClick);
//			vipGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			costBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			dayGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			tbuttons = new Vector.<TabButton>();
//			tbuttons.push(payGiftBtn);
//			tbuttons.push(collectWordGift);
//			tbuttons.push(wingGiftBtn);
//			tbuttons.push(rideGiftBtn);
//			tbuttons.push(boxGiftBtn);
//			tbuttons.push(lotteryGiftBtn);
//			tbuttons.push(vipGiftBtn);
//			tbuttons.push(costBtn);
//			tbuttons.push(dayGiftBtn);
////			payGiftBtn.turnOn();
////			currentType = 1;
////			turnTo(currentType);
//		}

//		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
//			super.show(toTop, $layer, toCenter);
//			Cmd_Fanl.cm_Fanl_I();
//		}
		
//		protected function onMouseClick(event:MouseEvent):void {
//			switch (event.target.name) {
//				case "payBtn":
//					PayUtil.openPayUrl();
//					break;
//				case "payGift":
//					turnTo(1);
//					break;
//				case "rideGift":
//					turnTo(2);
//					break;
//				case "wingGift":
//					turnTo(3);
//					break;
//				case "collectWordGift":
//					turnTo(4);
//					break;
//				case "boxGift":
//					turnTo(5);
//					break;
//				case "lotteryGift":
//					turnTo(6);
//					break;
//				case "vipGift":
//					turnTo(7);
//					break;
//				case "costBtn":
//					turnTo(8);
//					break;
//				case "dayGiftBtn":
//					turnTo(9);
//					break;
//			}
////			turnTo(currentType);
//		}
//
//		private function turnTo(type:int):void {
//			payGiftPanel.visible=false;
//			boxGiftPanel.visible=false;
//			rideGiftPanel.visible=false;
//			wingGiftPanel.visible=false;
//			collectWordPanel.visible=false;
//			lotteryRender.visible = false;
//			vipGiftPanel.visible=false;
//			costGiftPanel.visible=false;
//			dayGiftPanel.visible=false;
//			currentType=type;
//			switch (type) {
//				case 1:
//					payGiftBtn.turnOn();
//					payGiftPanel.visible=true;
//					var flagId:int=DataManager.getInstance().payPromotionData.getInfo(1, 0).id;
//					var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(flagId);
//					var v:int=DataManager.getInstance().payPromotionData.getMinPV();
//					if (v > 0) {
//						payLbl.htmlText=StringUtil.substitute(tinfo.des4, v);
//					} else {
//						payLbl.text=PropUtils.getStringById(1828);
//					}
//					timeLbl.htmlText=tinfo.des2;
//					ordinationLbl.htmlText=tinfo.des3;
//					break;
//				case 2:
//					rideGiftBtn.turnOn();
//					rideGiftPanel.visible=true;
//
//					var rtinfo:TPayPromotion=getPayPromotionInfo(2);
//					payLbl.htmlText=StringUtil.substitute(rtinfo.des4, DataManager.getInstance().payPromotionData.getMinRV());
//					timeLbl.htmlText=rtinfo.des2;
//					ordinationLbl.htmlText=rtinfo.des3;
//					break;
//				case 3:
//					wingGiftBtn.turnOn();
//					wingGiftPanel.visible=true;
//
//					var wtinfo:TPayPromotion=getPayPromotionInfo(3);
//					payLbl.htmlText=StringUtil.substitute(wtinfo.des4, DataManager.getInstance().payPromotionData.getMinWV());
//					timeLbl.htmlText=wtinfo.des2;
//					ordinationLbl.htmlText=wtinfo.des3;
//					break;
//				case 4:
//					collectWordGift.turnOn();
//					collectWordPanel.visible=true;
//					
//					var ctinfo:TPayPromotion=getPayPromotionInfo(4);
////					payLbl.htmlText=StringUtil.substitute(wtinfo.des4, DataManager.getInstance().payPromotionData.getMinWV());
//					payLbl.htmlText=ctinfo.des4;
//					timeLbl.htmlText=ctinfo.des2;
//					ordinationLbl.htmlText=ctinfo.des3;
//					break;
//				case 5:
//					boxGiftBtn.turnOn();
//					boxGiftPanel.visible=true;
//					
//					var btinfo:TPayPromotion=getPayPromotionInfo(5);
//					payLbl.htmlText=btinfo.des4;
//					timeLbl.htmlText=btinfo.des2;
//					ordinationLbl.htmlText=btinfo.des3;
//					break;
//				case 6:
//					lotteryGiftBtn.turnOn();
//					lotteryRender.visible=true;
//					
//					var ltinfo:TPayPromotion=getPayPromotionInfo(6);
//					payLbl.htmlText=ltinfo.des4;
//					timeLbl.htmlText=ltinfo.des2;
//					ordinationLbl.htmlText=ltinfo.des3;
//					break;
//				case 7:
//					vipGiftBtn.turnOn();
//					vipGiftPanel.visible=true;
//					
//					var vtinfo:TPayPromotion=getPayPromotionInfo(7);
//					payLbl.htmlText=vtinfo.des4;
//					timeLbl.htmlText=vtinfo.des2;
//					ordinationLbl.htmlText=vtinfo.des3;
//					break;
//				case 8:
//					costBtn.turnOn();
//					costGiftPanel.visible = true;
//					
//					var cotinfo:TPayPromotion=getPayPromotionInfo(8);
//					var cv:int = DataManager.getInstance().payPromotionData.getMinCV();
//					if(cv > 0){
//						payLbl.htmlText=StringUtil.substitute(cotinfo.des4, DataManager.getInstance().payPromotionData.getMinCV());
//					}else{
//						payLbl.htmlText="";
//					}
//					timeLbl.htmlText=cotinfo.des2;
//					ordinationLbl.htmlText=cotinfo.des3;
//					break;
//				case 9:
//					dayGiftBtn.turnOn();
//					dayGiftPanel.visible = true;
//					
//					var dinfo:TPayPromotion=getPayPromotionInfo(9);
//					timeLbl.htmlText=dinfo.des2;
//					ordinationLbl.htmlText=dinfo.des3;
//					var dv:int = DataManager.getInstance().payPromotionData.getMinV(9);
//					if(dv > 0){
//						payLbl.htmlText=StringUtil.substitute(dinfo.des4, dv);
//					}else{
//						payLbl.htmlText="";
//					}
//					break;
//			}
//		}
//		
//		public function getPayPromotionInfo(type:int):TPayPromotion{
//			var pInfo:TPayPromotion;
//			var proDic:Object = TableManager.getInstance().getPromotionDic();
//			for(var key:String in proDic){
//				var payPromotion:TPayPromotion = proDic[key];
//				if(null == pInfo && payPromotion.type == type){
//					pInfo = payPromotion;
//				}else if(null != pInfo && payPromotion.type == type && payPromotion.id < pInfo.id){
//					pInfo = payPromotion;
//				}
//			}
//			return pInfo;
//		}
//
//		public function updateInfo():void {
//			var data:PayPromotionData=DataManager.getInstance().payPromotionData;
//			var type:int=1;
//			var info:PayPromotionItem;
//			var length:int=data.getInfoLength(type);
//			payGiftBtn.visible=(length > 0);
//			payGiftRenders.length=length;
//			for (var n:int=0; n < length; n++) {
//				info=data.getInfo(type, n);
//				var render:PromotionSpendRender=payGiftRenders[n];
//				if (null == render) {
//					render=new PromotionSpendRender();
//					render.y=n * 104;
//					payGiftRenders[n]=render;
//				}
//				render.updateInfo(info);
//				if (!payGiftPanel.contains(render)) {
//					payGiftPanel.addToPane(render);
//				}
//			}
//			type=2;
//			length=data.getInfoLength(type);
//			rideGiftBtn.visible=(length > 0);
//			rideGiftRenders.length=length;
//			for (var m:int=0; m < length; m++) {
//				info=data.getInfo(type, m);
//				var hrender:PromotionHourseRender=rideGiftRenders[m];
//				if (null == hrender) {
//					hrender=new PromotionHourseRender();
//					hrender.y=m * 104;
//					rideGiftRenders[m]=hrender;
//				}
//				hrender.updateInfo(info);
//				if (!rideGiftPanel.contains(hrender)) {
//					rideGiftPanel.addToPane(hrender);
//				}
//			}
//			type=3;
//			length=data.getInfoLength(type);
//			wingGiftBtn.visible=(length > 0);
//			wingGiftRenders.length=length;
//			for (var k:int=0; k < length; k++) {
//				info=data.getInfo(type, k);
//				var wrender:PromotionWingRender=wingGiftRenders[k];
//				if (null == wrender) {
//					wrender=new PromotionWingRender();
//					wrender.y=k * 104;
//					wingGiftRenders[k]=wrender;
//				}
//				wrender.updateInfo(info);
//				if (!wingGiftPanel.contains(wrender)) {
//					wingGiftPanel.addToPane(wrender);
//				}
//			}
//			type=4;
//			length=data.getInfoLength(type);
//			collectWordGift.visible=(length > 0);
//			collectWordRenders.length=length;
//			for(var l:int = 0; l < length; l++){
//				info=data.getInfo(type, l);
//				var crender:PromotionExchangeRender=collectWordRenders[l];
//				if(null == crender){
//					crender=new PromotionExchangeRender();
//					crender.y=l * 104;
//					collectWordRenders[l]=crender;
//				}
//				crender.updateInfo(info);
//				if (!collectWordPanel.contains(crender)) {
//					collectWordPanel.addToPane(crender);
//					collectWordPanel.updateUI();
//				}
//			}
//			type=5;
//			length=data.getInfoLength(type);
//			boxGiftBtn.visible=(length > 0);
//			boxGiftRenders.length=length;
//			for(var h:int = 0; h < length; h++){
//				info=data.getInfo(type, h);
//				var brender:PromotionCollectWordRender=boxGiftRenders[h];
//				if(null == brender){
//					brender=new PromotionCollectWordRender();
//					brender.y=h * 104;
//					boxGiftRenders[h]=brender;
//				}
//				brender.updateInfo(info);
//				if (!boxGiftPanel.contains(brender)) {
//					boxGiftPanel.addToPane(brender);
//					boxGiftPanel.updateUI();
//				}
//			}
//			type=6;
//			var list1:Array = data.lotteryData1;
//			if(null == list1){
//				lotteryGiftBtn.visible = false;
//				lotteryRender.visible = false;
//			}else{
//				lotteryGiftBtn.visible = true;
//				lotteryRender.updateInfo();
//			}
//			type=7;
//			length=data.getInfoLength(type);
//			vipGiftBtn.visible=(length > 0);
//			vipGiftRenders.length=length;
//			for(var x:int = 0;x < length; x++){
//				info=data.getInfo(type, x);
//				var vrender:PromotionVipRender=vipGiftRenders[x];
//				if(null == vrender){
//					vrender=new PromotionVipRender();
//					vrender.y=x * 104;
//					vipGiftRenders[x]=vrender;
//				}
//				vrender.updateInfo(info);
//				if (!vipGiftPanel.contains(vrender)) {
//					vipGiftPanel.addToPane(vrender);
//					vipGiftPanel.updateUI();
//				}
//			}
//			type=8;
//			length=data.getInfoLength(type);
//			costBtn.visible=(length > 0);
//			costGiftRenders.length=length;
//			for(var y:int = 0; y < length; y++){
//				info=data.getInfo(type, y);
//				var corender:PromotionCostGiftRender=costGiftRenders[y];
//				if(null == corender){
//					corender=new PromotionCostGiftRender();
//					corender.y=y * 104;
//					costGiftRenders[y]=corender;
//				}
//				corender.updateInfo(info);
//				if (!costGiftPanel.contains(corender)) {
//					costGiftPanel.addToPane(corender);
//					costGiftPanel.updateUI();
//				}
//			}
//			
//			type=9;
//			length=data.getInfoLength(9);
//			dayGiftBtn.visible=(length > 0);
//			dayGiftRenders.length=length;
//			for(var z:int = 0; z < length; z++){
//				info=data.getInfo(type, z);
//				var drender:PromotionPayRender=dayGiftRenders[z];
//				if(null == drender){
//					drender=new PromotionPayRender();
//					drender.y=z * 104;
//					dayGiftRenders[z]=drender;
//				}
//				drender.updateInfo(info);
//				if (!dayGiftPanel.contains(drender)) {
//					dayGiftPanel.addToPane(drender);
//					dayGiftPanel.updateUI();
//				}
//			}
//			if (1 == currentType) {
//				var tinfo:TPayPromotion=getPayPromotionInfo(1);
//				var v:int=DataManager.getInstance().payPromotionData.getMinPV();
//				if (v > 0) {
//					payLbl.htmlText=StringUtil.substitute(tinfo.des4, v);
//				} else {
//					payLbl.text=PropUtils.getStringById(1828);
//				}
//			} else if (2 == currentType) {
//				var rtinfo:TPayPromotion=getPayPromotionInfo(2);
//				payLbl.htmlText=StringUtil.substitute(rtinfo.des4, DataManager.getInstance().payPromotionData.getMinRV());
//			} else if (3 == currentType) {
//				var wtinfo:TPayPromotion=getPayPromotionInfo(3);
//				payLbl.htmlText=StringUtil.substitute(wtinfo.des4, DataManager.getInstance().payPromotionData.getMinWV());
//			} else if (4 == currentType) {
//				var ctinfo:TPayPromotion=getPayPromotionInfo(4);
//				payLbl.htmlText=StringUtil.substitute(ctinfo.des4, DataManager.getInstance().payPromotionData.getMinWV());
//			} else if (5 == currentType) {
//				var btinfo:TPayPromotion=getPayPromotionInfo(5);
//				payLbl.htmlText=StringUtil.substitute(btinfo.des4, DataManager.getInstance().payPromotionData.getMinWV());
//			} else if (6 == currentType) {
//				var ltinfo:TPayPromotion=getPayPromotionInfo(6);
//				payLbl.htmlText=ltinfo.des4;
//			} else if (7 == currentType) {
//				var vtinfo:TPayPromotion=getPayPromotionInfo(7);
//				payLbl.htmlText=vtinfo.des4;
//			} else if(8 == currentType) {
//				var coinfo:TPayPromotion=getPayPromotionInfo(8);
//				var cv:int = DataManager.getInstance().payPromotionData.getMinCV();
//				if(cv > 0){
//					payLbl.htmlText=StringUtil.substitute(coinfo.des4, DataManager.getInstance().payPromotionData.getMinCV());
//				}else{
//					payLbl.htmlText="";
//				}
//			}else if(9 == currentType){
//				var dtinfo:TPayPromotion=getPayPromotionInfo(9);
//				var dv:int = DataManager.getInstance().payPromotionData.getMinV(9);
//				if(dv > 0){
//					payLbl.htmlText=StringUtil.substitute(dtinfo.des4, dv);
//				}else{
//					payLbl.htmlText="";
//				}
//			}
//			var index:int;
//			var ll:int = tbuttons.length;
//			for(var i:int = 0; i < ll; i++){
//				var btn:TabButton = tbuttons[i];
//				if(btn.visible){
//					btn.y = 229 + index * 43;
//					index++;
//					if(-1 == currentType){
//						currentType = getTypeByIndex(i);
//					}
//				}
//			}
//			turnTo(currentType);
////			if (payGiftBtn.visible) {
////				turnTo(1);
////			} else if (rideGiftBtn.visible) {
////				turnTo(2);
////			} else if (wingGiftBtn.visible) {
////				turnTo(3);
////			} else if(collectWordGift.visible){
////				turnTo(4);
////			}
//		}
//		
//		public function rollToPos(type:int, pos:int, num:int):void{
//			lotteryRender.rollToPos(type, pos, num);
//		}
//		
//		private function getTypeByIndex(index:int):int{
//			switch(index){
//				case 0:
//					return 1;
//				case 1:
//					return 4;
//				case 2:
//					return 3;
//				case 3:
//					return 2;
//				case 4:
//					return 5;
//				case 5:
//					return 6;
//				case 6:
//					return 7;
//				case 7:
//					return 8;
//			}
//			return 0;
//		}
//
//		public function flyItem(type:int, id:int):void {
//			if (1 == type) {
//				var length:int=0;
//				if (payGiftPanel.visible) {
//					length=payGiftRenders.length;
//					for (var n:int=0; n < length; n++) {
//						var render:PromotionSpendRender=payGiftRenders[n];
//						if (render.id == id) {
//							render.flyItem();
//						}
//					}
//				}
//			} else if (2 == type) {
//				if (rideGiftPanel.visible) {
//					length=rideGiftRenders.length;
//					for (var m:int=0; m < length; m++) {
//						var hrender:PromotionHourseRender=rideGiftRenders[m];
//						if (hrender.id == id) {
//							hrender.flyItem();
//						}
//					}
//				}
//			} else if (3 == type) {
//				if (wingGiftPanel.visible) {
//					length=wingGiftRenders.length;
//					for (var k:int=0; k < length; k++) {
//						var wrender:PromotionWingRender=wingGiftRenders[k];
//						if (wrender.id == id) {
//							wrender.flyItem();
//						}
//					}
//				}
//			}else if(4 == type) {
//				if (collectWordPanel.visible) {
//					length=collectWordRenders.length;
//					for (var l:int=0; l < length; l++) {
//						var crender:PromotionExchangeRender=collectWordRenders[l];
//						if (crender.id == id) {
//							crender.flyItem();
//						}
//					}
//				}
//			}else if(5 == type) {
//				if (boxGiftPanel.visible) {
//					length=boxGiftRenders.length;
//					for (var h:int=0; h < length; h++) {
//						var brender:PromotionCollectWordRender=boxGiftRenders[h];
//						if (brender.id == id) {
//							brender.flyItem();
//						}
//					}
//				}
//			}else if(7 == type) {
//				if (vipGiftPanel.visible) {
//					length=vipGiftRenders.length;
//					for (var x:int=0; x < length; x++) {
//						var vrender:PromotionVipRender=vipGiftRenders[x];
//						if (vrender.id == id) {
//							vrender.flyItem();
//						}
//					}
//				}
//			}else if(8 == type){
//				if (costGiftPanel.visible) {
//					length=costGiftRenders.length;
//					for (var y:int=0; y < length; y++) {
//						var corender:PromotionCostGiftRender=costGiftRenders[y];
//						if (corender.id == id) {
//							corender.flyItem();
//						}
//					}
//				}
//			}else if(9 == type){
//				if(dayGiftPanel.visible){
//					length=dayGiftRenders.length;
//					for (var z:int=0; z < length; z++) {
//						var drender:PromotionPayRender=dayGiftRenders[z];
//						if (drender.id == id) {
//							drender.flyItem();
//						}
//					}
//				}
//			}
//		}
	}
}
