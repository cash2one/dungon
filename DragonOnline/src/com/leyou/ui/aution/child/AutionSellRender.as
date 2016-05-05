package com.leyou.ui.aution.child {
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.aution.AutionItemData;
	
	import flash.events.MouseEvent;

	public class AutionSellRender extends AutoSprite {
		// 每页显示最大数量
		private static const ITEM_PAGE_COUNT_MAX:int = 8;
		// 可出售最大数量
		private static const ITEM_COUNT_MAX:int = 10;
		// 主界面控件
		private var pageLbl:Label;
		private var noticeLbl:Label;
		private var prviPageBtn:ImgButton;
		private var nextPageBtn:ImgButton;
		
		// 出售项目显示列表
		private var renders:Vector.<AutionSellItemLable>;
		// 出售项目数据列表
		private var itemData:Vector.<AutionItemData>;
		
		// 出售项目子分页
		private var tabBar:TabBar;
		private var sellTypeGold:AutionSellTypeGold;
		private var sellTypeItem:AutionSellTypeItem;
		private var currentPIdx:int;
		private var pageCount:int = 1;
		
		public function AutionSellRender() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionSellRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren = true;
			tabBar = getUIbyID("tabBar1") as TabBar;
			pageLbl = getUIbyID("pageLbl") as Label;
			noticeLbl = getUIbyID("noticeLbl") as Label;
			prviPageBtn = getUIbyID("prviPageBtn") as ImgButton;
			nextPageBtn = getUIbyID("nextPageBtn") as ImgButton;
			prviPageBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			nextPageBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			itemData = new Vector.<AutionItemData>();
			sellTypeGold = new AutionSellTypeGold();
			sellTypeItem = new AutionSellTypeItem();
			renders = new Vector.<AutionSellItemLable>(ITEM_PAGE_COUNT_MAX);
			tabBar.addToTab(sellTypeItem, 0);
			tabBar.addToTab(sellTypeGold, 1);
//			tabBar.setTabVisible(1, false);
			pageLbl.text = "1/1";
//			noticeLbl.opaqueBackground = 0xff00;
//			var format:TextFormat = noticeLbl.defaultTextFormat;
//			format.align = TextFormatAlign.CENTER;
//			noticeLbl.defaultTextFormat = format;
//			noticeLbl.text = "10";
//			tabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);
//			updateInfo();
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var btnName:String = event.target.name;
			switch(btnName){
				case "prviPageBtn":
					if(currentPIdx > 0){
						currentPIdx--;
						initPage();
					}
					break;
				case "nextPageBtn":
					if(currentPIdx < (pageCount-1)){
						currentPIdx++;
						initPage();
					}
					break;
			}
		}
		
//		private function onChangeIndex(evt:Event):void {
//			switch (tabBar.turnOnIndex) {
//				case 0:
//					break;
//				case 1:
//					break;
//			}
//		}
		
//		public function updateInfo():void {
//			var sellitemLabel:AutionSellItemLable;
//			for (var i:int=0; i < 7; i++) {
//				sellitemLabel = new AutionSellItemLable();
//				addChild(sellitemLabel);
//				sellitemLabel.x = 196;
//				sellitemLabel.y = 50 + i * 45;
//			}
//		}
		
		/**
		 * <T>加载页面</T>
		 * 
		 */		
		private function initPage():void {
			pageLbl.text = (currentPIdx+1) + "/" + pageCount;
			var begin:int = currentPIdx * ITEM_PAGE_COUNT_MAX;
			var dl:int = itemData.length - begin;
			for(var n:int = 0; n < ITEM_PAGE_COUNT_MAX; n++){
				var render:AutionSellItemLable = renders[n];
				if(n < dl){
					if(null == render){
						render = new AutionSellItemLable();
						render.x = 196;
						render.y = 51 + n * 44;
						addChild(render);
						renders[n] = render;
						render.setBackGround(n);
					}
					render.visible = true;
//					if(!contains(render)){
//					}
					render.updateInfo(itemData[begin+n]);
				}else{
					if(null != render){
						render.visible = false;
//						if(contains(render)){
//							removeChild(render);
//						}
					}
					
				}
			}
		}
		
		/**
		 * <T>加载出售列表</T>
		 * 
		 * @param ct 出售列表信息
		 * 
		 */		
		public function loadInfo(tb:Array):void{
			var length:int = tb.length;
			noticeLbl.text = ""+(ITEM_COUNT_MAX-length);
			itemData.length = length;
			for(var n:int = 0; n < length; n++){
				var nativeData:Array = tb[n];
				var data:AutionItemData = itemData[n];
				if(null == data){
					data = new AutionItemData();
					itemData[n] = data;
				}
				data.updata(nativeData);
			}
			currentPIdx = 0;
			var count:int  = Math.ceil(length / ITEM_PAGE_COUNT_MAX)
			pageCount = (0 == count) ? 1 : count;
			initPage();
			if(!sellTypeItem.switchGrid){
				sellTypeItem.clear();
			}
		}
		
		/**
		 * <T>加载最近出售物品价格</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public function loadLastPrice(o:Object):void{
			sellTypeItem.loadLastPrice(o);
		}
		
		/**
		 * <T>设置金钱和元宝的兑换</T>
		 * 
		 * @param mc 金钱数量
		 * @param gc 元宝数量
		 * 
		 */		
		public function loadRate(mc:uint, gc:uint):void{
			sellTypeGold.loadRate(mc, gc);
		}
		
		public function switchHandler(fromItem:GridBase):void{
			tabBar.turnToTab(0);
			sellTypeItem.switchHandler(fromItem);
		}
		
		public function clearSale():void
		{
			sellTypeItem.clear();
		}
	}
}
