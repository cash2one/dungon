package com.leyou.ui.market {
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.market.MarketItemInfo;
	import com.leyou.data.market.MarketPageInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.ui.arrow.AdWnd;
	import com.leyou.ui.market.child.MarketItemRender;
	import com.leyou.ui.market.child.MarketNumlistItem;
	import com.leyou.ui.market.child.MarketWingRender;
	import com.leyou.ui.market.child.TencentMarketItem;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MarketWnd extends AutoWindow {
		private var PAGE_IB:int = 1;
		private var PAGE_DISCOUNT:int = 3;
		private var PAGE_BIB:int = 4;
		
		//		private var isRequest:Boolean;
		private var gridList:ScrollPane;
		private var tabBar:TabBar;
		private var desLbl:Label;
		private var ingotLbl:Label;
		private var ingotBindLbl:Label;
		private var payBtn:ImgButton;
		private var timeLbl:Label;
		
		private var _currentIdx:int = -1; //tabber当前的idx
		private var renderArr:Vector.<MarketItemRender>;
		private var listArr:Vector.<MarketNumlistItem>;
		private var pageDatas:Vector.<MarketPageInfo>;
		private var ybbImg:Image;
		private var ybImg:Image;
		
		private var wingRender:MarketWingRender;
		
		private var wingExist:Boolean;
		
		private var marketDTab:TabBar;
		
		private var discountList1:Array;
		
		private var discountList2:Array;
		private var _currentDIndex:int=-1;
		
		private var adWnd:AdWnd;
		
		private var tencentImg:Image;
		
		private var tencentPanel:ScrollPane;
		private var tencentMarketItems:Vector.<TencentMarketItem>;
		
		public function MarketWnd() {
			super(LibManager.getInstance().getXML("config/ui/marketWnd.xml"));
			init();
		}
		
		private function init():void {
			gridList = getUIbyID("gridList") as ScrollPane;
			tabBar = getUIbyID("marketTabBar") as TabBar;
			desLbl = getUIbyID("desLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
			ingotLbl = getUIbyID("ingotLbl") as Label;
			ingotBindLbl = getUIbyID("ingotBindLbl") as Label;
			payBtn = getUIbyID("rechargeBtn") as ImgButton;
			marketDTab = getUIbyID("marketTabBar") as TabBar;
			ybbImg = getUIbyID("ybbImg") as Image;
			tencentImg = getUIbyID("tencentImg") as Image;
			var container:Sprite = new Sprite();
			container.name = ybbImg.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			ybbImg.parent.addChild(container);
			container.addChild(ybbImg);
			
			ybImg = getUIbyID("ybImg") as Image;
			container = new Sprite();
			container.name = ybImg.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			ybImg.parent.addChild(container);
			container.addChild(ybImg);
			
			tabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			
			listArr = new Vector.<MarketNumlistItem>(10);
			renderArr = new Vector.<MarketItemRender>();
			pageDatas = new Vector.<MarketPageInfo>();
			pageDatas.length = 4;
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			hideBg();
			clsBtn.x-=25;
			clsBtn.y+=22;
			marketDTab = getUIbyID("marketTab") as TabBar;
			marketDTab.addEventListener(TabbarModel.changeTurnOnIndex, onDiscountTal);
			marketDTab.turnToTab(0);
			if(!Core.PAY_OPEN){
				payBtn.setActive(false, 1, true);
			}else{
				payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}
			
			adWnd = new AdWnd();
			adWnd.hideClsBtn();
			pane.addChild(adWnd);
			adWnd.showPanel();
			adWnd.x = 58;
			adWnd.y = 75;
			pane.swapChildren(adWnd, marketDTab);
			
			tencentImg.visible = Core.isTencent;
			if(!Core.isTencent){
				tabBar.setTabVisible(0, false);
				tabBar.turnToTab(1);
			}else{
				tabBar.turnToTab(0);
			}
		}
		
		public function updateADState():void{
			adWnd.updateState();
		}
		
		public function setADStateVip(isbuy:Boolean):void{
			adWnd.setStateVip(isbuy);
		}
		
		public function setADStateTtsc(isbuy:Boolean):void{
			adWnd.setStateTtsc(isbuy);
		}
		
		public function setADStateWing(isOpen:Boolean):void{
			adWnd.setStateWing(isOpen);
		}
		
		protected function onDiscountTal(event:Event):void{
			if(_currentDIndex == marketDTab.turnOnIndex){
				return;
			}
			_currentDIndex = marketDTab.turnOnIndex;
			if(0 == marketDTab.turnOnIndex){
				showDiscountList(discountList1);
			}else{
				showDiscountList(discountList2);
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String;
			switch(event.target.name){
				case "ybbImg":
					content = TableManager.getInstance().getSystemNotice(9558).content;
					break;
				case "ybImg":
					content = TableManager.getInstance().getSystemNotice(9559).content;
					break;
				default:
					throw new Error("aution show money tip unknow fault");
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
			
		}
		
		protected function updateTime():void{
			var date:Date = new Date();
			var day:int;
			if(0 != date.day){
				day = 7  - date.day;
			}
			var hours:int   = 23 - date.hours;
			var minutes:int = 59 - date.minutes;
			var seconds:int = 59 - date.seconds;
			var time:uint = day * (24 * 1000 * 60 * 60) + hours * (1000 * 60 * 60) + minutes * (1000 * 60) + seconds * 1000;
			timeLbl.text = DateUtil.formatTime(time, 2);
		}
		
		/**
		 * <T>显示界面</T>
		 * 
		 */	
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			Cmd_Market.cm_Mak_I(1);
//			Cmd_Market.cm_Mak_L();
//			tabBar.turnToTab(_currentIdx);
			if((null != wingRender) && !wingRender.visible){
				if(Core.isTencent){
					tabBar.turnToTab(0);
				}else{
					tabBar.turnToTab(1);
				}
			}
			updataMoney();
			GuideManager.getInstance().removeGuide(16);
		}
		
		public override function hide():void{
			super.hide();
			if(MarketItemRender.buyWnd){
				MarketItemRender.buyWnd.hide();
			}
		}
		
		/**
		 * <T>重置按钮点击监听</T>
		 * 
		 * @param evt 鼠标事件
		 * 
		 */		
		private function onBtnClick(evt:MouseEvent):void {
			PayUtil.openPayUrl();
		}
		
		/**
		 * <T>分页按钮点击监听</T>
		 * 
		 * @param evt 鼠标事件
		 * 
		 */		
		private function onTabBarChangeIndex(evt:Event):void {
			if (_currentIdx == tabBar.turnOnIndex){
				return;
			}
			if(MarketItemRender.buyWnd){
				MarketItemRender.buyWnd.hide();
			}
			changeTable(tabBar.turnOnIndex)
		}
		
		public function changeTable(index:int):void{
			_currentIdx = index;
			if(index != tabBar.turnOnIndex){
				tabBar.turnToTab(index);
			}
			if(wingRender){
				wingRender.visible = false;
			}
			if(tencentPanel){
				tencentPanel.visible = false;
			}
			gridList.visible = false;
			// 翅膀特殊
			if(4 == _currentIdx){
				showWingRender();
				return;
			}else if(Core.isTencent && (0 == _currentIdx)){
				showTencentMarket();
				return;
			}
			gridList.visible = true;
			var requestIndex:int = getRealIndex(_currentIdx);
			Cmd_Market.cm_Mak_I(requestIndex);
//			initPage();
		}
		
		private function showWingRender():void{
			if(null == wingRender){
				wingRender = new MarketWingRender();
				wingRender.x = 275;
				wingRender.y = 93;
				wingRender.updateInfo();
				addChild(wingRender);
			}
			wingRender.visible = true;
		}
		
		private function showTencentMarket():void{
			if(null == tencentPanel){
				var tarr:Array = ConfigEnum.qqvip3.split("|");
				
				tencentMarketItems = new Vector.<TencentMarketItem>(tarr.length);
				tencentPanel = new ScrollPane(600, 440);
				tencentPanel.x = 275;
				tencentPanel.y = 93;
				addChild(tencentPanel);
				
				var l:int = tarr.length;
				for(var n:int = 0; n < l; n++){
					var titem:TencentMarketItem = tencentMarketItems[n];
					if(null == titem){
						titem = new TencentMarketItem();
						tencentMarketItems[n] = titem;
						titem.y = n*88;
						tencentPanel.addToPane(titem);
					}
					titem.updateInfo(n+1, tarr[n]);
				}
			}
			tencentPanel.visible = true;
		}
		
		private function getRealIndex(index:int):int{
			switch(index){
				case 1:
					return 1;
				case 2:
					return 3;
				case 3:
					return 4;
			}
			return 0;
		}
		
		/**
		 * <T>选中指定的分页</T>
		 * 
		 * @param pd 分页数据
		 * 
		 */		
		private function initPage(index:int):void{
			var pd:MarketPageInfo = pageDatas[index];
			// 同步显示对象和数据项数量
			var rLength:int = renderArr.length;
			var dLength:int = (null == pd) ? 0 : pd.count;
			if((rLength - dLength) > 0){
				for(var n:int = dLength; n < rLength; n++){
					var render:MarketItemRender = renderArr[n];
					gridList.delFromPane(render);
					render.die();
				}
				gridList.scrollTo(0);
			}
			renderArr.length = dLength;
			// 更新显示数据
			for(var m:int = 0; m < dLength; m++){
				var itemInfo:MarketItemInfo = pd.getItem(m);
				var r:MarketItemRender = renderArr[m];
				if(null == r){
					r = new MarketItemRender();
					renderArr[m] = r;
					r.y = m * 88;
					r.id = m;
					gridList.addToPane(r);
				}
				r.updateInfo(itemInfo);
			}
			gridList.scrollTo(0);
			gridList.updateUI();
		}
		
		/**
		 * <T>加载物品信息</T>
		 * 
		 * @param o 数据信息
		 * 
		 */		
		public function onItemListResponse(o:Object):void{
			if((null != wingRender) && wingRender.visible){
				return;
			}
			var index:int = o.mtype;
			var itemList:Array = o.list;
			var page:MarketPageInfo = pageDatas[index-1];
			if(null == page){
				page = new MarketPageInfo();
				pageDatas[index-1] = page;
			}
			page.clear();
			var length:int = itemList.length;
			for(var n:int = 0; n < length; n++){
				var marketItem:MarketItemInfo = page.getItem(n);
				if(null == marketItem){
					marketItem = new MarketItemInfo();
					page.push(marketItem);
				}
				marketItem.loadInfo(itemList[n], index);
			}
			initPage(index-1);
			updataMoney();
		}			
		
		public function setWingInfo(obj:Object):void{
//			wingExist = !obj.st && (Core.me.info.level >= ConfigEnum.WingOpenLv);
			wingExist = obj.st;
			if(wingExist){
				if(null == wingRender){
					wingRender = new MarketWingRender();
					wingRender.x = 275;
					wingRender.y = 93;
					wingRender.updateInfo();
					wingRender.visible = false;
					addChild(wingRender);
				}
			}else{
				if(null != wingRender){
					if(wingRender.visible){
						wingRender.forbid();
					}else{
						var display:DisplayObject = tabBar.getTabButton(4);
						if(null != display){
							tabBar.setTabVisible(4, false);
						}
						wingRender.die();
						wingRender = null;
					}
				}else{
					var tb:DisplayObject = tabBar.getTabButton(4);
					if(null != tb){
						tabBar.setTabVisible(4, false);
					}
				}
			}
		}
		
		/**
		 * <T>更新金钱</T>
		 * 
		 */		
		public function updataMoney():void {
			ingotLbl.text = StringUtil_II.sertSign(UIManager.getInstance().backpackWnd.byb);;
			ingotBindLbl.text = StringUtil_II.sertSign(UIManager.getInstance().backpackWnd.yb);
		}
		
		public function showDiscountList(list:Array):void{
			if(null == list){
				return;
			}
			var rLength:int = listArr.length;
			var dLength:int = list.length;
			if((rLength - dLength) > 0){
				for(var n:int = dLength; n < rLength; n++){
					var r:MarketNumlistItem = listArr[n];
					if(null != r && contains(r)){
						removeChild(r);
					}
				}
			}
			var rank:int = 1;
			var lastApply:int = 0;
			for(var m:int = 0; m < dLength; m++){
				// 取到信息
				var itemId:uint = list[m][0];
				var apply:uint = list[m][1];
				if(lastApply > apply){
					rank++;
				}
				lastApply = apply;
				// 加载显示项
				var rankItem:MarketNumlistItem = listArr[m];
				if(null == rankItem){
					rankItem = new MarketNumlistItem();
					listArr[m] = rankItem;
				}
				rankItem.x = 59;
				rankItem.y = m * 30 + 273;
				rankItem.id = m;
				rankItem.updateInfo(itemId, rank, apply);
				addChild(rankItem);
			}
		}
		
		public function turnToTab(index:int):void{
			tabBar.turnToTab(index);
		}
		
		/**
		 * <T>加载折扣列表排名</T>
		 * 
		 * @param o 数据信息
		 * 
		 */		
		public function onDiscountListResponse(o:Object):void{
			var list:Array = o.list;
			if(1 == o.ltype){
				discountList1 = o.list.concat();
			}else{
				discountList2 = o.list.concat();
			}
			if(0 == marketDTab.turnOnIndex){
				showDiscountList(discountList1);
			}else{
				showDiscountList(discountList2);
			}
		}
		
		/**
		 * <T>处理回应,更新数据</T>
		 * 
		 * @param o 数据信息
		 * 
		 */		
		public function onApplyDiscountResponse(o:Object):void{
			var index:int = o.mtype;
			var page:MarketPageInfo = pageDatas[index-1];
			var dataArray:Array = o.one;
			var targetData:MarketItemInfo = page.searchItem(dataArray[0]);
			targetData.loadInfo(dataArray, index);
		}
		
		public override function get width():Number{
			return 937;
		}
		
		public override function get height():Number{
			return 546;
		}
		
		/**
		 * <T>当前的页签id</T>
		 * 
		 * @return 索引
		 *
		 */
		public function get currentIdx():int {
			return getRealIndex(_currentIdx);
		}
		
		/**
		 * <T>重置位置</T>
		 * 
		 */		
		public function resize():void {
			x=(UIEnum.WIDTH - width) / 2;
			y=(UIEnum.HEIGHT - height) / 2;
		}
		
		public function flyMovie():void{
			hide();
			if(null != wingRender){
				wingRender.flyMovie();
			}
		}
	}
}