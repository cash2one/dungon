package com.leyou.ui.missionMarket.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.missinMarket.MissionMarketChapterData;
	import com.leyou.data.missinMarket.MissionMarketData;

	public class MissionMarketRender extends AutoSprite
	{
		private static const ITEM_COUNT:int = 4;
		
		private var desLbl:Label;
		
		private var items:Vector.<MissionMarketItem>;
		
		private var switchFun:Function;
		
		public var currentType:int;
		
		public function MissionMarketRender(){
			super(LibManager.getInstance().getXML("config/ui/missionMarket/missionabarRender1.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			desLbl = getUIbyID("desLbl") as Label;
			
			items = new Vector.<MissionMarketItem>(ITEM_COUNT);
			for(var n:int = 0; n < ITEM_COUNT; n++){
				var item:MissionMarketItem = new MissionMarketItem();
				addChild(item);
				items[n] = item;
				item.x = 2 + n * 173;
				item.y = 0;
			}
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(23100).content;
		}
		
		public function registerSwitch(fun:Function):void{
			switchFun = fun;
			for(var n:int = 0; n < ITEM_COUNT; n++){
				var item:MissionMarketItem = items[n];
				item.registerSwitch(switchView);
			}
		}
		
		public function switchView(type:int):void{
			currentType = type;
			if(null != switchFun){
				switchFun.call(this);
			}
		}
		
		public function updateInfo(data:MissionMarketData):void{
			for(var n:int = 0; n < ITEM_COUNT; n++){
				var cdata:MissionMarketChapterData = data.getChapterData(n);
				if(null != cdata){
					items[n].updateInfo(cdata);
				}
			}
		}
		
		public function flyItem(type:int):void{
			for(var n:int = 0; n < ITEM_COUNT; n++){
				if((n+1) == type){
					items[n].flyItem();
				}
			}
		}
	}
}