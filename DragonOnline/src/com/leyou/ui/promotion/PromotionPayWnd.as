package com.leyou.ui.promotion
{
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
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;
	import com.leyou.ui.promotion.children.PromotionHourseRender;
	import com.leyou.ui.promotion.children.PromotionPayRender;
	import com.leyou.ui.promotion.children.PromotionWingRender;
	
	public class PromotionPayWnd extends AutoWindow
	{
		private var timeLbl:Label;
		
		private var ordinationLbl:Label;
		
		private var payBtn:ImgButton;
		
		private var payGiftBtn:TabButton;
		
		private var rideGiftBtn:TabButton;
		
		private var wingGiftBtn:TabButton;
		
		private var payGiftPanel:ScrollPane;
		
		private var rideGiftPanel:ScrollPane;
		
		private var wingGiftPanel:ScrollPane;
		
		private var payGiftRenders:Vector.<PromotionPayRender>;
		
		private var rideGiftRenders:Vector.<PromotionHourseRender>;
		
		private var wingGiftRenders:Vector.<PromotionWingRender>;
		
		private var currentType:int;
		
		private var payLbl:Label;
		
		public function PromotionPayWnd(){
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqWnd.xml"));
			init();
		}
		
		public function init():void{
			hideBg();
			timeLbl = getUIbyID("timeLbl") as Label;
			ordinationLbl = getUIbyID("ordinationLbl") as Label;
			payBtn = getUIbyID("payBtn") as ImgButton;
			payGiftBtn = getUIbyID("payGift") as TabButton;
			rideGiftBtn = getUIbyID("rideGift") as TabButton;
			wingGiftBtn = getUIbyID("wingGift") as TabButton;
			payGiftPanel = getUIbyID("payGiftPanel") as ScrollPane;
			rideGiftPanel = getUIbyID("rideGiftPanel") as ScrollPane;
			wingGiftPanel = getUIbyID("wingGiftPanel") as ScrollPane;
			payLbl = getUIbyID("payLbl") as Label;
			payLbl.multiline = true;
			payLbl.wordWrap = true;
			payGiftRenders = new Vector.<PromotionPayRender>();
			rideGiftRenders = new Vector.<PromotionHourseRender>();
			wingGiftRenders = new Vector.<PromotionWingRender>();
			clsBtn.y += 20;
			payGiftPanel.mouseChildren = true;
			rideGiftPanel.mouseChildren = true;
			wingGiftPanel.mouseChildren = true;
			if(!Core.PAY_OPEN){
				payBtn.setActive(false, 1, true);
			}else{
				payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			payGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			rideGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			wingGiftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			payGiftBtn.turnOn();
//			currentType = 1;
//			turnTo(currentType);
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			Cmd_Fanl.cm_Fanl_I();
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "payBtn":
					PayUtil.openPayUrl();
					break;
				case "payGift":
					turnTo(1);
					break;
				case "rideGift":
					turnTo(2);
					break;
				case "wingGift":
					turnTo(3);
					break;
			}
//			turnTo(currentType);
		}
		
		private function turnTo(type:int):void{
			currentType = type;
			switch(type){
				case 1:
					payGiftBtn.turnOn();
					payGiftPanel.visible = true;
					rideGiftPanel.visible = false;
					wingGiftPanel.visible = false;
					var flagId:int = DataManager.getInstance().payPromotionData.getInfo(1, 0).id;
					var tinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(flagId);
					var v:int = DataManager.getInstance().payPromotionData.getMinPV();
					if(v > 0){
						payLbl.htmlText = StringUtil.substitute(tinfo.des4, v);
					}else{
						payLbl.text = "欢迎您明天再来！";
					}
					timeLbl.htmlText = tinfo.des2;
					ordinationLbl.htmlText = tinfo.des3;
					break;
				case 2:
					rideGiftBtn.turnOn();
					payGiftPanel.visible = false;
					rideGiftPanel.visible = true;
					wingGiftPanel.visible = false;
					
					var rtinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(9);
					payLbl.htmlText = StringUtil.substitute(rtinfo.des4, DataManager.getInstance().payPromotionData.getMinRV());
					timeLbl.htmlText = rtinfo.des2;
					ordinationLbl.htmlText = rtinfo.des3;
					break;
				case 3:
					wingGiftBtn.turnOn();
					payGiftPanel.visible = false;
					rideGiftPanel.visible = false;
					wingGiftPanel.visible = true;
					
					var wtinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(14);
					payLbl.htmlText = StringUtil.substitute(wtinfo.des4, DataManager.getInstance().payPromotionData.getMinWV());
					timeLbl.htmlText = wtinfo.des2;
					ordinationLbl.htmlText = wtinfo.des3;
					break;
			}
		}
		
		public function updateInfo():void{
			var data:PayPromotionData = DataManager.getInstance().payPromotionData;
			var type:int = 1;
			var info:PayPromotionItem;
			var length:int = data.getInfoLength(type);
			payGiftBtn.visible = (length > 0);
			payGiftRenders.length = length;
			for(var n:int = 0; n < length; n++){
				info = data.getInfo(type, n);
				var render:PromotionPayRender = payGiftRenders[n];
				if(null == render){
					render = new PromotionPayRender();
					render.y = n * 104;
					payGiftRenders[n] = render;
				}
				render.updateInfo(info);
				if(!payGiftPanel.contains(render)){
					payGiftPanel.addToPane(render);
				}
			}
			type = 2;
			length = data.getInfoLength(type);
			rideGiftBtn.visible = (length > 0);
			rideGiftRenders.length = length;
			for(var m:int = 0; m < length; m++){
				info = data.getInfo(type, m);
				var hrender:PromotionHourseRender = rideGiftRenders[m];
				if(null == hrender){
					hrender = new PromotionHourseRender();
					hrender.y = m * 104;
					rideGiftRenders[m] = hrender;
				}
				hrender.updateInfo(info);
				if(!rideGiftPanel.contains(hrender)){
					rideGiftPanel.addToPane(hrender);
				}
			}
			type = 3;
			length = data.getInfoLength(type);
			wingGiftBtn.visible = (length > 0);
			wingGiftRenders.length = length;
			for(var k:int = 0; k < length; k++){
				info = data.getInfo(type, k);
				var wrender:PromotionWingRender = wingGiftRenders[k];
				if(null == wrender){
					wrender = new PromotionWingRender();
					wrender.y = k * 104;
					wingGiftRenders[k] = wrender;
				}
				wrender.updateInfo(info);
				if(!wingGiftPanel.contains(wrender)){
					wingGiftPanel.addToPane(wrender);
				}
			}
			if(1 == currentType){
				var tinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(1);
				var v:int = DataManager.getInstance().payPromotionData.getMinPV();
				if(v > 0){
					payLbl.htmlText = StringUtil.substitute(tinfo.des4, v);
				}else{
					payLbl.text = "欢迎您明天再来！";
				}
			}else if(2 == currentType){
				var rtinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(9);
				payLbl.htmlText = StringUtil.substitute(rtinfo.des4, DataManager.getInstance().payPromotionData.getMinRV());
			}else if(3 == currentType){
				var wtinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(12);
				payLbl.htmlText = StringUtil.substitute(wtinfo.des4, DataManager.getInstance().payPromotionData.getMinWV());
			}
			if(payGiftBtn.visible){
				turnTo(1);
			}else if(rideGiftBtn.visible){
				turnTo(2);
			}else if(wingGiftBtn.visible){
				turnTo(3);
			}
		}
		
		public function flyItem(type:int, id:int):void{
			if(1 == type){
				var length:int = 0;
				if(payGiftPanel.visible){
					length = payGiftRenders.length;
					for(var n:int = 0; n < length; n++){
						var render:PromotionPayRender = payGiftRenders[n];
						if(render.id == id){
							render.flyItem();
						}
					}
				}
			}else if(2 == type){
				if(rideGiftPanel.visible){
					length = rideGiftRenders.length;
					for(var m:int = 0; m < length; m++){
						var hrender:PromotionHourseRender = rideGiftRenders[m];
						if(hrender.id == id){
							hrender.flyItem();
						}
					}
				}
			}else if(3 == type){
				if(wingGiftPanel.visible){
					length = wingGiftRenders.length;
					for(var k:int = 0; k < length; k++){
						var wrender:PromotionWingRender = wingGiftRenders[k];
						if(wrender.id == id){
							wrender.flyItem();
						}
					}
				}
			}
		}
	}
}