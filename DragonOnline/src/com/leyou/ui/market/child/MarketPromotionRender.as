package com.leyou.ui.market.child
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.market.MarketItemInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.ui.shop.BuyWnd;
	import com.leyou.util.DateUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class MarketPromotionRender extends AutoSprite
	{
//		private var timeTitleLbl:Label;
		
//		private var timeLbl:Label;
		
		private var proNameLbl:Label;
		
		private var priceLbl:Label;
		
		private var npriceLbl:Label;
		
		private var buiedCountLbl:Label;
		
		private var buyBtn:NormalButton;
		
		private var grid:MarketGrid;
		
		private var buyWnd:BuyWnd;
		
		private var dataLink:MarketItemInfo;

		public var pid:int;

		private var remainT:int;
		
		private var tick:uint;
		
		private var buiedImg:Image;

		private var price:int;

		private var itemId:int;

		private var _bnum:int = -1; 
		
		public function MarketPromotionRender(){
			super(LibManager.getInstance().getXML("config/ui/market/marketSRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
//			timeTitleLbl = getUIbyID("timeTitleLbl") as Label;
//			timeLbl = getUIbyID("timeLbl") as Label;
			npriceLbl = getUIbyID("npriceLbl") as Label;
			proNameLbl = getUIbyID("proNameLbl") as Label;
			priceLbl = getUIbyID("priceLbl") as Label;
			buiedCountLbl = getUIbyID("buiedCountLbl") as Label;
			buyBtn = getUIbyID("buyBtn") as NormalButton;
			buiedImg = getUIbyID("buyImg") as Image;
			buyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			grid=new MarketGrid();
			grid.isShowPrice = false;
			grid.x=10;
			grid.y=18;
			addChild(grid);
			swapChildren(grid, buiedImg);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(2014).content;
			content = StringUtil.substitute(content, price, TableManager.getInstance().getItemInfo(itemId).name);
			PopupManager.showConfirm(content, buyCall, null, false, "market.limit.buy");
//			if(null == buyWnd){
//				buyWnd = new BuyWnd();
//			}
//			//				buyWnd.setKeepMode(false);
//			buyWnd.updateMarket(dataLink);
//			LayerManager.getInstance().addPopWnd(false, buyWnd);
//			buyWnd.show();
		}
		
		private function buyCall():void{
			Cmd_Market.cm_Mak_G(pid, 1);
		}
		
//		public function addTimer():void{
//			if(!TimeManager.getInstance().hasITick(updateTime)){
//				TimeManager.getInstance().addITick(1000, updateTime)
//			}
//		}
//		
//		public function removeTimer():void{
//			if(TimeManager.getInstance().hasITick(updateTime)){
//				TimeManager.getInstance().removeITick(updateTime)
//			}
//		}
		
//		private function updateTime():void{
//			var rt:int = remainT*1000 - (getTimer() - tick);
//			if(rt < 0){
//				rt = 0;
//				removeTimer();
//				Cmd_Market.cm_Mak_I(1);
//			}
//			timeLbl.text = DateUtil.formatTime(rt, 2)
//		}
		
		public function updateInfo(obj:Object):void{
			tick = getTimer();
			var lbuy:Array = obj.lbuy;
			var status:int = lbuy[0];
			remainT = lbuy[1];
			pid = lbuy[2];
			itemId = lbuy[3];
			price = lbuy[4];
			var lnum:int = lbuy[5]; //-- 限制购买次数
			var bnum:int = lbuy[6]; //-- 已购买次数
			var nprice:int = lbuy[7];
			
//			if(remainT > 0){
//				addTimer();
//			}
			if(null == dataLink){
				dataLink = new MarketItemInfo();
			}
			// 更换物品
			if(dataLink.itemId != itemId){
				_bnum = -1;
			}
			dataLink.itemId = itemId;
			dataLink.buyType = 6;
			dataLink.price = price;
			dataLink.nowPrice = price;
			dataLink.moneyType = 2;
			
			var cid:int = (0 == status) ? 2012 : 2013;
			buyBtn.visible = (1 == status);
//			timeTitleLbl.text = TableManager.getInstance().getSystemNotice(cid).content;
//			timeLbl.text = DateUtil.formatTime(remainT*1000, 2);
			proNameLbl.text = TableManager.getInstance().getItemInfo(itemId).name;
			priceLbl.text = price+"";
			npriceLbl.text = nprice+"";
			grid.updataById(itemId);
			buyBtn.setActive((lnum != bnum), 1, true);
			buiedImg.visible = (lnum == bnum);
//			if((1 == status) && (lnum != bnum)){
//				TweenMax.to(buyBtn, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});
//			}else{
//				TweenMax.killTweensOf(buyBtn);
//				buyBtn.filters = null;
//			}
			
			if((-1 != _bnum) && (_bnum != bnum)){
				FlyManager.getInstance().flyBags([grid.dataId], [grid.localToGlobal(new Point())]);
			}
			_bnum = bnum;
		}
	}
}